import 'package:frontend/components/constants/book_status.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/models/collection.dart';
import 'package:frontend/models/word.dart';
import 'package:frontend/services/settings.dart';
import 'package:frontend/services/sql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:more/iterable.dart' as it;

final fisher = DB.shared.fisher;

class DB with SettingProviderMixin {
  late Database fisher;

  static final shared = DB();

  initialize() async {
    fisher = await openDatabase('fisher.db', version: 1, onCreate: _onCreateDatabase, onUpgrade: _onUpgradeDatabase);
  }

  /// 创建单词本
  Future saveBook(Book book, List<List<dynamic>> words) => fisher.transaction((txn) async {
        final batch = txn.batch();
        batch.execute(SQLStatement.createWordTable(book.wordTableName));
        for (final word in words) {
          if (word.length != 2) continue;
          batch.insert(book.wordTableName, {'name': word[0], 'mean': word[1]});
        }
        batch.insert('book', {'id': book.id, 'name': book.name});
        await batch.commit();
      });

  /// 保存单词
  Future saveWordHistory(Book book, Word word) => fisher.transaction((txn) async {
        final timestamp = DateTime.now().microsecondsSinceEpoch ~/ 1000;
        final batch = txn.batch();
        batch.update(book.wordTableName, {'readTime': word.readTime, 'degree': word.degree, 'updateTime': timestamp},
            where: 'id = ?', whereArgs: [word.id]);
        batch.insert('history', {'bookId': book.id, 'wordId': word.id, 'timestamp': timestamp});
        await batch.commit();
      });

  /// 同步数据库中的缓存数据
  syncBooks(List<Book> books) async => await fisher.transaction((txn) async {
        final batch = txn.batch();
        for (var book in books) {
          batch.query('book', where: 'id = ?', whereArgs: [book.id]);
        }
        final result = await batch.commit();
        [books, result].zip().forEach((element) {
          final book = element[0] as Book;
          final dbResult = element[1] as List<Map<String, Object?>>;
          if (dbResult.isEmpty) return;
          final map = dbResult.first;
          book.hasDownload.value = map.isNotEmpty;
          book.readStatus = map.isEmpty ? BookReadStatus.unread : BookReadStatus.values[map['readStatus'] as int];
        });
      });

  /// 获取所有缓存的图书
  Future<List<Book>> get cachedBooks async => await fisher.transaction((txn) async {
        final results = await txn.query(FisherTable.book.name);
        return results.map((e) => Book.fromJson(e)..hasDownload.value = true).toList();
      });

  /// 更新书籍状态
  Future updateBookStatus(Book book, BookReadStatus readStatus) => fisher.transaction((txn) async {
        final batch = txn.batch();

        switch (readStatus) {
          case BookReadStatus.unread:
            // 重置所有单词状态
            batch.update(book.wordTableName, {'degree': 0, 'readTime': 0, 'updateTime': 0});
            break;
          case BookReadStatus.reading:
            // 重置上次阅读的书籍
            batch.update('book', {'readStatus': BookReadStatus.readSuspend.index},
                where: 'readStatus = ?', whereArgs: [BookReadStatus.reading.index]);
            break;
          default:
            break;
        }

        batch.update('book', {'readStatus': readStatus.index}, where: 'id = ?', whereArgs: [book.id]);

        await batch.commit();
      });

  /// 最近一次读的书
  Future<Book?> lastReadBook() async {
    List<Map> maps = await fisher.query('book', where: 'readStatus = ?', whereArgs: [BookReadStatus.reading.index]);
    if (maps.isEmpty) return null;
    final map = maps.first;
    final book = Book.fromJson(map as Map<String, dynamic>);
    book.hasDownload.value = true;
    return book;
  }

  /// 获取一组单词
  /// 1. 未背诵完 2. 更新时间不是今天
  Future<List<Word>> fetchWords(Book book) async {
    final today = DateTime.now();
    final lastTime = today.subtract(const Duration(hours: 24)).microsecondsSinceEpoch ~/ 1000;
    var result = await DB.shared.fisher.query(book.wordTableName,
        where: 'degree < ? AND updateTime < ?',
        whereArgs: [settings.mode.wordDegree, lastTime],
        limit: settings.wordNumber);
    if (result.isEmpty) {
      result = await DB.shared.fisher.query(book.wordTableName,
          where: 'degree < ?', whereArgs: [settings.mode.wordDegree], limit: settings.wordNumber);
    }
    return result.map((e) => Word.fromJson(e)).toList();
  }

  /// 收藏单词
  Future collect(Book book, Word word) async {
    final isExist = firstIntValue(await fisher.query(FisherTable.collection.name,
            columns: ['COUNT(*)'], where: 'bookId = ? AND wordId = ?', whereArgs: [book.id, word.id]))! >
        0;
    if (isExist) return;
    return fisher.insert(FisherTable.collection.name, {'bookId': book.id, 'wordId': word.id});
  }

  /// 查询收藏的单词
  Future<List<Collection>> collections() async => fisher.transaction((txn) async {
        var list = await txn.query(FisherTable.collection.name);
        final batch = txn.batch();
        for (final item in list) {
          final book = Book.fromJson(
              (await txn.query(FisherTable.book.name, where: 'id = ?', whereArgs: [item['bookId']])).first);
          batch.query(book.wordTableName, where: 'id = ?', whereArgs: [item['wordId']]);
        }
        final queryList = await batch.commit();
        var words = queryList.fold([], (previousValue, element) => (previousValue as List) + (element as List));
        return words.map((element) {
          final index = words.indexOf(element);
          return Collection(list[index]['id'] as int, Word.fromJson(element as Map<String, dynamic>));
        }).toList();
      });

  /// 删除收藏的单词
  Future deleteCollection(Collection collection) =>
      fisher.delete(FisherTable.collection.name, where: 'id = ?', whereArgs: [collection.id]);

  /// 书籍信息
  bookStat(List<Book> books) async => fisher.transaction((txn) async {
        for (final book in books) {
          final batch = txn.batch();
          batch.query(book.wordTableName, columns: ['COUNT(*)']);
          batch.query(book.wordTableName,
              columns: ['COUNT(*)'], where: 'degree >= ?', whereArgs: [settings.mode.wordDegree]);
          final result = await batch.commit();

          book.wordCount = firstIntValue(result[0] as List<Map<String, Object?>>) ?? 0;
          final completedCount = firstIntValue(result[1] as List<Map<String, Object?>>) ?? 0;
          book.progress = completedCount / book.wordCount;
        }
      });

  /// 创建数据库
  _onCreateDatabase(Database db, int version) async {
    final sqlVersion = FisherSQLVersion.values[version - 1];
    _execute(db.batch(), sqlVersion.sqlList);
  }

  /// 升级数据库
  _onUpgradeDatabase(Database db, int oldVersion, int newVersion) async {
    final sqlVersion = FisherSQLVersion.values[newVersion - 1];
    _execute(db.batch(), sqlVersion.upgradeSqlList);
  }

  /// 执行升级语句
  _execute(Batch batch, List<String> sqlList) {
    for (var sql in sqlList) {
      batch.execute(sql);
    }
    batch.commit();
  }
}

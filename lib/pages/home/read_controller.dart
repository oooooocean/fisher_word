import 'package:frontend/components/constants/book_status.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/models/word.dart';
import 'package:frontend/services/alg.dart';
import 'package:frontend/services/db.dart';
import 'package:frontend/services/settings.dart';
import 'package:get/get.dart';

enum HomeStatus {
  /// 无书可读
  none,

  /// 正在读
  reading,

  /// 读完一组单词
  groupCompleted,

  /// 读完一本书
  bookCompleted
}

class ReadController with SettingProviderMixin {
  Book? book;
  Word? currentWord;
  List<Word> words = [];
  Rx<HomeStatus> homeStatus = HomeStatus.none.obs;
  final db = DB.shared;
  int? completedCursor;

  /// 选择最后一次读的图书
  Future<bool> prepareLastReadBook() async {
    final book = await db.lastReadBook();
    if (book == null) return false;
    await prepareBook(book); // 准备单词
    return true;
  }

  /// 读取图书
  prepareBook(Book book) async {
    this.book = book;
    await book.changeReadStatus(BookReadStatus.reading);
    words.clear(); // 换书
    currentWord = null;
  }

  /// 准备读下一个单词
  Future<Word?> nextWord() async {
    if (completedCursor == null || completedCursor == 0) {
      words = await DB.shared.fetchWords(book!); // 本组单词全部背诵完成, 获取下一组单词
      if (words.isEmpty) {
        await hasReadBook(); // 书籍读完
        changePageState(HomeStatus.bookCompleted);
      } else {
        completedCursor = words.length;
        changePageState(HomeStatus.groupCompleted);
      }

      return null;
    }

    currentWord = words.first;
    changePageState(HomeStatus.reading);
    return currentWord;
  }

  /// 用户选择熟练度
  /// 循环背诵一组单词, 直到所有单词达标当日目标
  selectAlg(Alg alg) async {
    await currentWord!.read(book: book!, alg: alg);
    words.remove(currentWord!);
    if (currentWord!.todayDegree >= settings.mode.wordDegreeEveryday) {
      completedCursor = completedCursor! - 1;
      words.insert(words.length, currentWord!); // 数据插入到最后
    } else {
      words.insert(completedCursor! - 1, currentWord!); // 数据插入到未读部分的最后
    }
  }

  /// 读完图书
  hasReadBook() async {
    currentWord = null;
    words.clear();
    await book?.changeReadStatus(BookReadStatus.read);
    changePageState(HomeStatus.bookCompleted);
  }

  /// 改变界面样式
  changePageState(HomeStatus status) {
    if (homeStatus.value == status) return;
    homeStatus.value = status;
  }
}

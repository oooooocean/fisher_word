enum FisherTable {
  /// 单词本
  book,

  /// 阅读历史
  history,

  /// 收藏
  collection
}

enum FisherSQLVersion {
  version_1;

  /// 创建语句
  List<String> get sqlList {
    switch (this) {
      case FisherSQLVersion.version_1:
        return [
          'CREATE TABLE IF NOT EXISTS ${FisherTable.book.name} ('
              'id INTEGER PRIMARY KEY, '
              'name TEXT NOT NULL, '
              'readStatus INTEGER DEFAULT 0)',
          'CREATE TABLE IF NOT EXISTS ${FisherTable.collection.name} ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'bookId INTEGER NOT NULL, '
              'wordId INTEGER NOT NULL)',
          'CREATE TABLE IF NOT EXISTS ${FisherTable.history.name} ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'bookId INTEGER NOT NULL, '
              'wordId INTEGER NOT NULL, '
              'timestamp INTEGER NOT NULL)',
        ];
    }
  }

  /// 升级语句
  List<String> get upgradeSqlList {
    return [];
  }
}

class SQLStatement {
  /// 创建单词表
  static String createWordTable(String tableName) => 'CREATE TABLE IF NOT EXISTS $tableName ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT NOT NULL, '
      'mean TEXT NOT NULL, '
      'readTime INTEGER DEFAULT 0,'
      'degree INTEGER DEFAULT 0, '
      'updateTime INTEGER DEFAULT 0)';
}

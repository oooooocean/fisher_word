import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/components/constants/book_status.dart';
import 'package:frontend/components/mixins/refresh_mixin.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/models/paging_data.dart';
import 'package:frontend/net/net_mixin.dart';
import 'package:frontend/services/db.dart';
import 'package:get/get.dart';
import 'package:more/more.dart';

class BookListController extends GetxController with NetMixin, RefreshMixin<Book> {
  load(RefreshType refreshType) {
    startRefresh(refreshType).then((_) => update());
  }

  /// 选择阅读的图书
  select(Book book) async {
    if (!book.hasDownload.value) {
      await fetch(book); // 下载
    }
    if (book.readStatus == BookReadStatus.read) {
      // 已读转未读
      final needRestart = await Get.defaultDialog<bool>(
          title: '提示',
          content: const Text('您已背完这本书啦, 确认要重新背诵吗?'),
          confirmTextColor: Colors.white,
          textConfirm: '确认',
          textCancel: '取消',
          onConfirm: () => Get.back(result: true));
      if (needRestart != null && needRestart) {
        await DB.shared.updateBookStatus(book, BookReadStatus.unread);
      }
    }
    Get.back(result: book);
  }

  /// 获取图书
  Future fetch(Book book) {
    EasyLoading.show();
    return download(book)
        .then((value) => saveBook(value.first, value.second))
        .then((_) {
          book.hasDownload.value = true;
          return '下载成功';
        })
        .catchError((error) => '下载失败, 希望您联系我反馈该问题~')
        .then((value) {
          EasyLoading.dismiss();
          EasyLoading.showToast(value);
        });
  }

  /// 下载书籍
  Future<Tuple2<Book, String>> download(Book book) => net
      .get('upload/${book.path}', contentType: 'text/csv', decoder: (data) => data)
      .then((res) => Tuple2(book, res.body));

  /// 保存书籍到数据库
  Future<int> saveBook(Book book, String content) {
    final words = const CsvToListConverter().convert(content, eol: '\n');
    return DB.shared.saveBook(book, words).then((_) => words.length);
  }

  @override
  Future<PagingData<Book>> get refreshRequest async {
    var hasNet = (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
    if (!hasNet) {
      final books = await DB.shared.cachedBooks;
      return PagingData(books.length, books);
    }

    return get('api/v1/book/', (data) => PagingData.fromJson(data, Book.fromJson),
        query: {'page': paging.current.toString()}).then((value) {
      DB.shared.syncBooks(value.items);
      return value;
    });
  }
}

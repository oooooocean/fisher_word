import 'package:flutter/material.dart';
import 'package:frontend/components/constants/ui.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/models/paging_data.dart';
import 'package:frontend/pages/book/book_list_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookListPage extends GetView<BookListController> {
  const BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: GetBuilder<BookListController>(
          builder: (_) => SmartRefresher(
            enablePullUp: true,
            controller: controller.refreshController,
            onRefresh: () => controller.load(RefreshType.refresh),
            onLoading: () => controller.load(RefreshType.loadMore),
            child: GridView.count(
              padding: EdgeInsets.symmetric(vertical: kSpacePadding, horizontal: kDefaultPadding),
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              children: controller.items.map(_buildBook).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBook(Book book) => GestureDetector(
        onTap: () => controller.select(book),
        child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(kSpacePadding),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(book.readStatus.toString(), style: const TextStyle(fontSize: 10, color: kOrangeColor))),
                _buildBookName(book),
                Align(alignment: Alignment.centerRight, child: _buildBookAction(book))
              ]),
            )),
      );

  Widget _buildBookName(Book book) {
    final components = book.nameComponents;
    return Text.rich(
      TextSpan(
          text: components.first,
          style: const TextStyle(fontSize: 24),
          children: [TextSpan(text: components.second, style: const TextStyle(fontSize: kDefaultFont))]),
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBookAction(Book book) => Obx(() {
        final icon = Icon(book.hasDownload.value ? Icons.download_done : Icons.cloud_download);
        return book.hasDownload.value
            ? icon
            : GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => controller.fetch(book), child: icon);
      });
}

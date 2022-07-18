import 'package:flutter/material.dart';
import 'package:frontend/pages/stat/stat_controller.dart';
import 'package:get/get.dart';

class StatPage extends GetView<StatController> {
  const StatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: controller.obx(
        (_) => ListView.separated(
            itemBuilder: _itemBuilder,
            separatorBuilder: (_, __) => const Divider(),
            itemCount: controller.books.length),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final book = controller.books[index];
    return ListTile(
      title: Text(book.name),
      subtitle: Text('单词量: ${book.wordCount} 当前进度: ${(book.progress * 100).toStringAsFixed(2)}%'),
      trailing: OutlinedButton(
        onPressed: () => controller.reset(book),
        child: const Text('重置进度', style: TextStyle(color: Colors.redAccent)),
      ),
    );
  }
}

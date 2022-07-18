import 'package:flutter/material.dart';
import 'package:frontend/pages/collection/collection_controller.dart';
import 'package:get/get.dart';

class CollectionPage extends GetView<CollectionController> {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('收藏')),
        extendBodyBehindAppBar: true,
        body: controller.obx((_) => ListView.separated(
            itemBuilder: _itemBuilder,
            separatorBuilder: (_, __) => const Divider(),
            itemCount: controller.collections.length)));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final word = controller.collections[index].word;
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Text(word.name),
      subtitle: Text(word.mean),
      trailing: IconButton(onPressed: () => controller.delete(index), icon: const Icon(Icons.delete)),
    );
  }
}

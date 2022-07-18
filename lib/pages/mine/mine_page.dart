import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/components/constants/ui.dart';
import 'package:frontend/pages/mine/mine_controller.dart';
import 'package:frontend/route/pages.dart';
import 'package:get/get.dart';

class MinePage extends GetView<MineController> {
  const MinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 0.5,
      elevation: 3,
      child: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.analytics, color: Colors.purple),
              title: const Text('统计'),
              onTap: () => Get.toNamed(AppRoutes.stat)),
          ListTile(
              leading: const Icon(Icons.collections, color: Colors.lightGreen),
              title: const Text('收藏'),
              onTap: controller.toCollection),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.lightBlue),
            title: const Text('背诵设置'),
            onTap: () => Get.toNamed(AppRoutes.settings),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.lime),
            title: const Text('关于作者和App'),
            onTap: () => Get.toNamed(AppRoutes.about),
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              title: const Text('退出'),
              onTap: () => exit(0))
        ],
      ),
    );
  }

  Widget get _header => const DrawerHeader(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/fisher_bg.webp'))),
      child: Text(
        'Touch Fish 单词',
        style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            shadows: [Shadow(color: kOrangeColor, offset: Offset(-1, -1), blurRadius: 5)]),
      ));
}

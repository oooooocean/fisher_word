import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/constants/ui.dart';
import 'package:frontend/pages/home/home_controller.dart';
import 'package:frontend/pages/home/read_controller.dart';
import 'package:frontend/pages/mine/mine_page.dart';
import 'package:frontend/route/pages.dart';
import 'package:frontend/services/alg.dart';
import 'package:get/get.dart';
import 'package:more/more.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Stack(children: [
          Builder(
              builder: (context) =>
                  IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.more_horiz))),
          Positioned(right: 0, top: 0, child: _statItem),
          Obx(() {
            switch (controller.readCtl.homeStatus.value) {
              case HomeStatus.none:
                return _emptyPage;
              case HomeStatus.reading:
                return _content;
              case HomeStatus.groupCompleted:
                return _groupCompletedPage;
              case HomeStatus.bookCompleted:
                return _bookCompletedPage;
            }
          }),
        ]),
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: controller.toBookList,
          child: const Icon(Icons.book, color: kOrangeColor)),
      drawer: const MinePage(),
    );
  }

  Widget get _content => GetBuilder<HomeController>(
        id: 'word',
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _wordItem,
            Padding(padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding), child: _meanItem),
            _actionBar
          ],
        ),
      );

  Widget get _meanItem => Obx(
        () => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.showMean.value = !controller.showMean.value,
          child: Center(
            child: Visibility(
                visible: controller.showMean.value,
                replacement: Center(
                    child: Text('点击查看释义~', style: TextStyle(color: kGreyColor, fontSize: Platform.isMacOS ? 14 : 20))),
                child: Text(controller.readCtl.currentWord!.mean,
                    textAlign: TextAlign.center, style: TextStyle(color: kSecondaryTextColor2, fontSize: kButtonFont))),
          ),
        ),
      );

  Widget get _wordItem => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onDoubleTap: controller.collect,
            behavior: HitTestBehavior.opaque,
            child: Text(controller.readCtl.currentWord!.name,
                style: TextStyle(
                    color: kOrangeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: kWordFont,
                    decorationColor: kShapeColor,
                    decoration: TextDecoration.underline)),
          ),
          SizedBox(width: kSpacePadding),
          GestureDetector(
              onTap: () => controller.playVoice(controller.readCtl.currentWord!),
              behavior: HitTestBehavior.opaque,
              child: Icon(Icons.volume_up_sharp, color: kGreyColor))
        ],
      );

  Widget get _actionBar => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Alg.values
            .map((e) => IconButton(
                visualDensity: VisualDensity.comfortable,
                padding: EdgeInsets.all(3 * kSpacePadding),
                iconSize: kWordFont,
                icon: Icon(e.iconData, color: e.iconColor),
                onPressed: () => controller.selectAlg(e)))
            .toList(),
      );

  Widget get _statItem => GetBuilder<HomeController>(
      id: 'stat',
      builder: (_) {
        if (controller.readCtl.words.isEmpty) return Container();
        final progress = controller.progress;
        return TextButton(
            onPressed: () => Get.to(AppRoutes.stat),
            child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(
                  value: progress.first / progress.second, backgroundColor: kShapeColor, color: Colors.lightGreen),
              Text.rich(
                TextSpan(
                    text: progress.first.toString(),
                    children: [TextSpan(text: '/${progress.second}', style: const TextStyle(fontSize: 12))],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                style: const TextStyle(color: kSecondaryTextColor),
              )
            ]));
      });

  Widget get _emptyPage => _buildPage(const Tuple3('欢迎大家使用', '摸鱼单词🐶', '\n\n\n选本单词书开始背诵吧~👇👇👇👇👇'));

  Widget get _groupCompletedPage =>
      _buildPage(const Tuple3('👏👏👏👏👏', '\n点击这里再背一组', '\n\n\内置记忆曲线, 下次自动温习'), onTap: controller.read);

  Widget get _bookCompletedPage =>
      _buildPage(const Tuple3('🎆🎆🎆🎆🎆本书已背完啦\n', '摸鱼单词🐶', '\n\n\n换本单词书开始背诵吧~👇👇👇👇👇'));

  Widget _buildPage(Tuple3<String, String, String> texts, {VoidCallback? onTap}) {
    final child = Center(
      child: Text.rich(
          TextSpan(text: texts.first, children: [
            TextSpan(
                text: texts.second,
                style: const TextStyle(color: kOrangeColor, fontSize: 24, fontWeight: FontWeight.bold)),
            TextSpan(text: texts.third)
          ]),
          textAlign: TextAlign.center),
    );
    if (onTap == null) return child;
    return GestureDetector(onTap: onTap, child: child);
  }
}

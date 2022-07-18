import 'package:flutter/material.dart';
import 'package:frontend/components/constants/ui.dart';
import 'package:frontend/pages/mine/about_controller.dart';
import 'package:get/get.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
          child: const Text.rich(
            TextSpan(text: '欢迎大家使用', children: [
              TextSpan(text: '摸鱼单词🐶', style: TextStyle(color: kOrangeColor, fontSize: 24, fontWeight: FontWeight.bold)),
              TextSpan(text: '\n\n\n设计该App的目的是为了利用上班的碎片时间背诵英语单词.\n\n'),
              TextSpan(
                  text: '它有这些功能:\n', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
              TextSpan(text: '- 永久免费, 记忆曲线, 几十个单词本\n', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '- 双击单词->收藏该单词\n'),
              TextSpan(text: '- 设置-背诵设置->定制背诵选项\n\n'),
              TextSpan(text: '因精力优先, 下面的功能只能在以后慢慢补充😭:\n'),
              TextSpan(text: '[x] 开放手机端, windows端的下载(如果有这方面需求请联系作者提供)\n'),
              TextSpan(text: '[x] 云端数据保存, 目前数据只保存在您自己的电脑里哦~\n\n\n'),
              TextSpan(text: '如果您有好的建议或打赏作者😊, 欢迎联系作者, WX👇👇👇\n'),
              TextSpan(text: 'chenqiangsf', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/components/constants/ui.dart';
import 'package:frontend/pages/mine/setting_controller.dart';
import 'package:frontend/services/settings.dart';
import 'package:get/get.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('背诵设置')),
      body: GetBuilder<SettingController>(
          builder: (_) => ListView(children: [_modeItem, _wordNumberItem, _showMeanItem, _showAutoPlayItem])),
    );
  }

  Widget get _modeItem => _buildDropDownListTile<WordMode>(
      title: '背诵模式',
      values: WordMode.values,
      onChanged: (mode) => controller.changeMode(mode!),
      value: controller.settings.mode);

  Widget get _wordNumberItem => _buildDropDownListTile<int>(
      title: '每组单词量',
      values: controller.wordNumbers,
      onChanged: (number) => controller.changeWordNumber(number!),
      value: controller.settings.wordNumber);

  Widget get _showMeanItem =>
      _buildSwitchTile(title: '显示单词解释', value: controller.settings.showMean, onChanged: controller.changeShowMean);

  Widget get _showAutoPlayItem =>
      _buildSwitchTile(title: '自动播放语音', value: controller.settings.autoPlay, onChanged: controller.changeAutoPlay);

  Widget _buildTitle(String text) => Text(text);

  Widget _buildDropDownListTile<T>(
      {required String title, required List<T> values, required ValueSetter<T?> onChanged, required T value}) {
    final items = values
        .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e.toString(), style: const TextStyle(color: kSecondaryTextColor, fontSize: kSmallFont))))
        .toList();
    return ListTile(
        visualDensity: VisualDensity.compact,
        title: _buildTitle(title),
        trailing: DropdownButton<T>(focusColor: Colors.transparent, items: items, value: value, onChanged: onChanged));
  }

  Widget _buildSwitchTile({required String title, required ValueSetter<bool> onChanged, required bool value}) =>
      SwitchListTile(title: _buildTitle(title), value: value, onChanged: onChanged);
}

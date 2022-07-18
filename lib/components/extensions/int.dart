import 'package:get/get.dart';

extension IntThemeSupport on int {
  double get toPadding => Get.width / 390 * this;
}
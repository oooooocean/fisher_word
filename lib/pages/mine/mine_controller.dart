import 'package:frontend/route/pages.dart';
import 'package:get/get.dart';

class MineController extends GetxController {
  toCollection() {
    Get.toNamed(AppRoutes.collectionList);
  }
}
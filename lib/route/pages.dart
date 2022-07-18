import 'package:frontend/pages/book/book_list.dart';
import 'package:frontend/pages/book/book_list_controller.dart';
import 'package:frontend/pages/collection/collection_controller.dart';
import 'package:frontend/pages/collection/collection_page.dart';
import 'package:frontend/pages/home/home_controller.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/pages/mine/about_controller.dart';
import 'package:frontend/pages/mine/about_page.dart';
import 'package:frontend/pages/mine/setting_controller.dart';
import 'package:frontend/pages/mine/setting_page.dart';
import 'package:frontend/pages/stat/stat_controller.dart';
import 'package:frontend/pages/stat/stat_page.dart';
import 'package:get/get.dart';

part 'routes.dart';

final appRoutes = [
  GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder((() => Get.lazyPut(() => HomeController())))),
  GetPage(
      name: AppRoutes.bookList,
      page: () => const BookListPage(),
      binding: BindingsBuilder((() => Get.lazyPut(() => BookListController())))),
  GetPage(
      name: AppRoutes.collectionList,
      page: () => const CollectionPage(),
      binding: BindingsBuilder((() => Get.lazyPut(() => CollectionController())))),
  GetPage(
      name: AppRoutes.settings,
      page: () => const SettingPage(),
      binding: BindingsBuilder((() => Get.lazyPut(() => SettingController())))),
  GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
      binding: BindingsBuilder((() => Get.lazyPut(() => AboutController())))),
  GetPage(
      name: AppRoutes.stat,
      page: () => const StatPage(),
      binding: BindingsBuilder((() => Get.lazyPut(() => StatController())))),
];

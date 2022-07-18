import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/components/constants/ui.dart';
import 'package:frontend/route/pages.dart';
import 'package:frontend/services/db.dart';
import 'package:frontend/services/settings.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.shared.initialize();
  await Settings.initialize();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key) {
    _customLoading();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        enableLog: const bool.fromEnvironment('dart.vm.product'),
        getPages: appRoutes,
        builder: EasyLoading.init(),
        theme: themeData);
  }

  /// custom loading
  /// see https://pub.dev/packages/flutter_easyloading
  void _customLoading() {
    EasyLoading.instance
      ..userInteractions = false
      ..dismissOnTap = false
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.grey
      ..indicatorColor = Colors.orange
      ..textColor = Colors.white
      ..indicatorType = EasyLoadingIndicatorType.circle;
  }

  /// theme
  ThemeData get themeData => ThemeData(
        buttonTheme: const ButtonThemeData(hoverColor: Colors.transparent),
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: kPrimaryTextColor), labelLarge: TextStyle(color: kPrimaryTextColor)),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: kGreyColor),
            counterStyle: TextStyle(color: kGreyColor),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kBorderColor)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kGreyColor))),
        appBarTheme: const AppBarTheme(
            toolbarHeight: 30,
            iconTheme: IconThemeData(color: kSecondaryTextColor2, size: 16),
            foregroundColor: kSecondaryTextColor,
            backgroundColor: kBackgroundColor,
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kPrimaryTextColor)),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                foregroundColor: MaterialStateProperty.all(kPrimaryTextColor))),
        scaffoldBackgroundColor: kBackgroundColor,
      );
}

import 'package:frontend/services/settings.dart';
import 'package:get/get.dart';

class SettingController extends GetxController with SettingProviderMixin {
  final wordNumbers = [10, 20, 30, 50, 100];

  changeMode(WordMode mode) {
    settings.mode = mode;
    update();
  }

  changeWordNumber(int number) {
    settings.wordNumber = number;
    update();
  }

  changeShowMean(bool showMean) {
    settings.showMean = showMean;
    update();
  }

  changeAutoPlay(bool autoPlay) {
    settings.autoPlay = autoPlay;
    update();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    settings.save();
    super.update(ids, condition);
  }
}

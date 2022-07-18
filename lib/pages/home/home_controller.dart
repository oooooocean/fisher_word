import 'dart:ffi';
import 'package:frontend/components/mixins/refresh_mixin.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/models/word.dart';
import 'package:frontend/pages/home/read_controller.dart';
import 'package:frontend/pages/mine/mine_controller.dart';
import 'package:frontend/route/pages.dart';
import 'package:frontend/services/alg.dart';
import 'package:frontend/services/db.dart';
import 'package:frontend/services/settings.dart';
import 'package:frontend/services/tts.dart';
import 'package:get/get.dart';
import 'package:more/more.dart';

class HomeController extends GetxController with StateMixin<Void>, RefreshMixin<Book>, SettingProviderMixin {
  var showMean = false.obs;
  final readCtl = ReadController();

  @override
  void onReady() async {
    Get.lazyPut(() => MineController());
    bool hasBook = await readCtl.prepareLastReadBook();
    if (hasBook) read();
    super.onReady();
  }

  /// 收藏
  collect() async {
    await DB.shared.collect(readCtl.book!, readCtl.currentWord!);
    Get.showSnackbar(const GetSnackBar(
      message: '已收藏',
      duration: Duration(seconds: 1),
      snackStyle: SnackStyle.GROUNDED,
      animationDuration: Duration(milliseconds: 250),
    ));
  }

  /// 用户选择熟练度
  /// 循环背诵一组单词, 直到所有单词达标当日目标
  selectAlg(Alg alg) async {
    await readCtl.selectAlg(alg);
    read();
  }

  /// 读
  read() async {
    final word = await readCtl.nextWord();
    if (word == null) {
      update(['stat']);
      return;
    }
    showMean.value = settings.showMean; // 重置到设置
    if (settings.autoPlay) playVoice(word);
    update(['word', 'stat']); // 更新界面
  }

  /// 播放声音
  playVoice(Word word) => TTS.shared.play(word.name);

  /// 跳转到书单列表
  toBookList() async {
    final result = (await Get.toNamed(AppRoutes.bookList)) as Book?;
    if (result == null) return;
    readCtl.prepareBook(result);
    read();
  }

  /// 本组单词进度
  Tuple2<int, int> get progress => Tuple2(
      readCtl.completedCursor == null ? 0 : readCtl.words.length - readCtl.completedCursor!, readCtl.words.length);
}

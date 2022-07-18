import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  static final shared = TTS();
  final tts = FlutterTts();

  TTS() {
    prepare();
    tts.setErrorHandler((message) {
      print('播放单词失败: $message');
    });
  }

  prepare() async {
    if (Platform.isIOS) {
      await tts.setSharedInstance(true);
      await tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers
          ],
          IosTextToSpeechAudioMode.voicePrompt);
    }
    await tts.awaitSpeakCompletion(true);
    await tts.setLanguage('en-US');


  }

  Future play(String word) async {
    await tts.setSpeechRate(0.5);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    return tts.speak(word);
  }

  Future stop() {
    return tts.stop();
  }
}

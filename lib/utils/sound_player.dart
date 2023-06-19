import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';

final pathToSaveAudio = 'audio.aac';

class SoundPlayer {
  FlutterSoundPlayer? _soundPlayer;

  Future init() async {
    _soundPlayer = FlutterSoundPlayer();
    await _soundPlayer!.openPlayer();
  }

  void dispose() {
    _soundPlayer!.stopPlayer();
    _soundPlayer = null;
  }

  Future _play(VoidCallback whenFinished) async {
    await _soundPlayer!.startPlayer();
  }

  Future _stop() async {
    await _soundPlayer!.closePlayer();
  }

  Future togglePlay({required VoidCallback whenFinished}) async {
    if (_soundPlayer!.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}

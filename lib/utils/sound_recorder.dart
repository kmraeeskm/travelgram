import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isrecorderinitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('microphone access not granted');
    }
    await _audioRecorder!.openRecorder();
    _isrecorderinitialized = true;
  }

  void dispose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isrecorderinitialized = false;
  }

  Future _record() async {
    if (!_isrecorderinitialized) return;
    await _audioRecorder!.startRecorder(
      toFile: '/data/user/0/com.example.mentor_mind/cache/audio.aac',
    );
  }

  Future _stop() async {
    if (!_isrecorderinitialized) return;
    final path = await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}

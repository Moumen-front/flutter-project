import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as rec;

class AudioRecorderService {
  final rec.AudioRecorder _record = rec.AudioRecorder();
  String _filePath = "";

  // 🔥 بدء التسجيل
  Future<void> startRecording() async {
    final hasPermission = await _record.hasPermission();
    if (!hasPermission) {
      throw Exception("Microphone permission not granted");
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        "record_${DateTime.now().millisecondsSinceEpoch}.wav";

    _filePath = "${directory.path}/$fileName";

    await _record.start(
      const rec.RecordConfig(
        encoder: rec.AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _filePath,
    );
  }

  // 🔥 إيقاف التسجيل
  Future<String> stopRecording() async {
    if (await _record.isRecording()) {
      await _record.stop();
    }
    return _filePath;
  }

  // 🔥 Pause
  Future<void> pauseRecording() async {
    if (await _record.isRecording()) {
      await _record.pause();
    }
  }

  // 🔥 Resume
  Future<void> resumeRecording() async {
    if (await _record.isPaused()) {
      await _record.resume();
    }
  }

  Future<bool> isRecording() => _record.isRecording();
  Future<bool> isPaused() => _record.isPaused();
}

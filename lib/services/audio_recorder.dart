import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:record/record.dart' as rec;

class AudioRecorderService {
  final rec.AudioRecorder _record = rec.AudioRecorder();

  String _filePath = "";
  final _amplitudeController = StreamController<double>.broadcast();

  /// Stream of normalized amplitude (-40 to 0 mapped to 0.0 - 1.0)
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  /// Start recording
  Future<void> startRecording() async {
    final hasPermission = await _record.hasPermission();
    if (!hasPermission) {
      throw Exception("Microphone permission not granted");
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = "record_${DateTime.now().millisecondsSinceEpoch}.wav";
    _filePath = "${directory.path}/$fileName";

    await _record.start(
      const rec.RecordConfig(
        encoder: rec.AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _filePath,
    );
    // periodically check amplitude
    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (await _record.isRecording()) {
        final amp = await _record.getAmplitude();
        double normalized = _normalizeAmplitude(amp.current);
        _amplitudeController.add(normalized);
      } else {
        timer.cancel();
        _amplitudeController.add(0.0); // reset
      }
    });
  }

  /// Stop recording
  Future<String> stopRecording() async {
    if (await _record.isRecording()) {
      await _record.stop();
    }
    _amplitudeController.add(0.0); // reset
    return _filePath;
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    if (await _record.isRecording()) {
      await _record.pause();
    }
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    if (await _record.isPaused()) {
      await _record.resume();
    }
  }

  Future<bool> isRecording() => _record.isRecording();
  Future<bool> isPaused() => _record.isPaused();

  void dispose() {
    _amplitudeController.close();
  }

  /// normalize amplitude from roughly -40..0 to 0.0..1.0
  double _normalizeAmplitude(double amplitude) {
    const minAmp = -40.0;
    const maxAmp = 0.0;
    final clamped = amplitude.clamp(minAmp, maxAmp);
    return (clamped - minAmp) / (maxAmp - minAmp);
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as rec;

class AudioRecorderService {
  final rec.AudioRecorder _record = rec.AudioRecorder();

  String _filePath = "";
  final _amplitudeController = StreamController<double>.broadcast();

  ///the time when the record has started
  int _startTime = 0;
///all the time spent during pauseing
  int _accumalaitedPauseTime = 0;
/// the time when the pause started
  int _pauseStartTime = 0;
  ///time when last pause/resume
  int _lastInteractTime = 0;
  /// Stream of normalized amplitude (-40 to 0 mapped to 0.0 to 1.0)
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  int getDuration()
  {
   return ((DateTime.now().millisecondsSinceEpoch - _startTime - _accumalaitedPauseTime)/1000).toInt();
  }

  int _getDurationMilliSeconds()
  {
    return (DateTime.now().millisecondsSinceEpoch - _startTime - _accumalaitedPauseTime);
  }


  /// Start recording
  Future<void> startRecording() async {
    final hasPermission = await _record.hasPermission();
    if (!hasPermission) {
      throw Exception("Microphone permission not granted");
    }

    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = "record_${DateTime
          .now()
          .millisecondsSinceEpoch}.wav";
      _filePath = "${directory.path}/$fileName";
    }
    else{
      _filePath = "ignoredname"; // the path parameter is ignored on web

      final directory = await getApplicationDocumentsDirectory(); // to make it crash so the recording don't work , as for now i cant get to make it work smoothly on web, it be so laggy
    }
    await _record.start(
      const rec.RecordConfig(
        encoder: rec.AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
      ),
      path: _filePath,
    );
    _startTime = DateTime.now().millisecondsSinceEpoch;
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

    _accumalaitedPauseTime = 0;

    return _filePath;
  }

  /// Pause recording
  Future<bool> pauseRecording() async {

    if (await _record.isRecording() && !await _record.isPaused()) { // the second condition here is for disabling the toggling half second befor ethe half time so that it works well when we pause
      ///todo: BUG, if there were a bug regarding pausing/resuming the recording, remember to changet eh cooldown duration here and in the resume function if the max time was changed
      if(DateTime.now().millisecondsSinceEpoch - _lastInteractTime <= 1500 || (_getDurationMilliSeconds()<3000 && _getDurationMilliSeconds()>=1500 ) ) ///todo: refactor this as it is repeated in the resume function too
        {
          return false;
        }
      await _record.pause();
      _pauseStartTime = DateTime.now().millisecondsSinceEpoch;
      _lastInteractTime = DateTime.now().millisecondsSinceEpoch;
      return true;
    }
    return false;
  }

  /// Resume recording
  Future<bool> resumeRecording() async {
    if (await _record.isRecording() && await _record.isPaused()) {

      if(DateTime.now().millisecondsSinceEpoch - _lastInteractTime <= 1500)
      {

        return false;
      }

      await _record.resume();
      _accumalaitedPauseTime +=   (DateTime.now().millisecondsSinceEpoch - _pauseStartTime);
      _lastInteractTime = DateTime.now().millisecondsSinceEpoch;
      return true;
    }
    return false;
  }

  Future<bool> isRecording() => _record.isRecording();
  Future<bool> isPaused() => _record.isPaused();

  void dispose() {
    ///todo: rememerb to cancel all the timer when disposing i think
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

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_recorder.dart';
import '../widgets/mic_button.dart';

class RecordScreen2 extends ConsumerStatefulWidget {
  const RecordScreen2({super.key});

  @override
  ConsumerState<RecordScreen2> createState() => _RecordScreen2State();
}

class _RecordScreen2State extends ConsumerState<RecordScreen2> {
  bool isRecording = false;
  bool isPaused = false;

  /// true when the user is recording for the first letter, and false for when they are recording for the second letter
  bool isFirstPhase = true;

  ///changes from 5 to 10 when the user finishes recording the first letter
  int currentMaxSeconds = 5;
  int seconds = 0;
  Timer? _timer;

  //initializing the record service
  final AudioRecorderService recorder = AudioRecorderService();

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
      if (seconds >= currentMaxSeconds && isRecording) {
        if (isFirstPhase) {
          toggleRecording();
          isFirstPhase = false;
          currentMaxSeconds = 10;
        }
        else {
          stopRecording();
        }
      }
    });
  }

  void toggleRecording() async {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      stopTimer();
      await recorder.pauseRecording();
    } else {
      startTimer();
      await recorder.resumeRecording();
    }
  }

  void stopRecording() async {
    stopTimer();

    // stoping the record and saving it
    final filePath = await recorder.stopRecording();
    //todo: EID, delete this test part in production
    //this is for testing only, it should be commented out after confirming that the record is good
    AudioPlayer().play(DeviceFileSource(filePath));
    //end of the testing
    setState(() {
      isRecording = false;
      isPaused = false;
    });

    // displaying the saved file path
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Saved: $filePath")));
  }

  void cancelRecording() async {
    stopTimer();

    await recorder.stopRecording();

    setState(() {
      isRecording = false;
      isPaused = false;
      seconds = 0;
      currentMaxSeconds = 5;
      isFirstPhase = true;
    });
  }

  void startRecording() async {
    if(isRecording) {
      return;
    }
    setState(() {
      isRecording = true;
      currentMaxSeconds = 5;
      isFirstPhase = true;
      isPaused=true;
    });

    if (isRecording) {
      seconds = 0;

      await recorder.startRecording();
      // to let the user read the instructions first
      await recorder.pauseRecording();

    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  String formatTime(int totalSeconds) {
    return "${totalSeconds.toString().padLeft(2, '0')}/${currentMaxSeconds
        .toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MicButton(
            isRecording: isRecording,
            onTap:startRecording,
          ),

          const SizedBox(height: 5),

          if (!isRecording)
            Column(
              children: [
                const SizedBox(height: 6),
                const Icon(Icons.arrow_upward, color: Colors.white, size: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Tap here to start recording",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 30),

          Text(
            formatTime(seconds),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          if (isRecording)
            Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFirstPhase?"press the play button and record a 5 seconds AAAA tone":"now record another 5 seconds but with OOOOO tone",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      //cancel
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: cancelRecording,
                      ),
                    ),

                    const SizedBox(width: 20),

                    //  Pause /  Resume
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrangeAccent,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPaused ? Icons.play_arrow : Icons.pause,
                          color: Colors.black,
                          size: 32,
                        ),
                        onPressed: toggleRecording,
                      ),
                    ),

                    const SizedBox(width: 20),

                    //  Save
                    // commented out bc we dont want the user to be able to end the recording early
                    //  Container(
                    //  decoration: const BoxDecoration(
                    //    shape: BoxShape.circle,
                    //    color: Colors.white,
                    //  ),
                    //  child: IconButton(
                    //    icon: const Icon(
                    //      Icons.check,
                    //      color: Colors.black,
                    //      size: 30,
                    //    ),
                    //    onPressed: stopRecording,
                    //  ),
                    //),

                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

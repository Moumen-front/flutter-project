import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool doneRecording = false;

  /// true when the user is recording for the first letter, and false for when they are recording for the second letter
  bool isFirstPhase = true;

  ///changes from 5 to 10 when the user finishes recording the first letter
  int currentMaxSeconds = 5;
  int seconds = 0;
  Timer? _timer;
  String? filePath;

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
        } else {
          stopRecording();
        }
      }
    });
  }

  void toggleRecording() async {
    if(!isRecording)
      {
        startRecording();
        return;
      }
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
    if (!isRecording) {
      return;
    }
    stopTimer();

    // stoping the record and saving it
    filePath = await recorder.stopRecording();

    setState(() {
      isRecording = false;
      isPaused = false;
      doneRecording = true;
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
      doneRecording = false;
      currentMaxSeconds = 5;
      isFirstPhase = true;
    });
  }

  void startRecording() async {
    if (isRecording) {
      return;
    }
    setState(() {
      isRecording = true;
      currentMaxSeconds = 5;
      isFirstPhase = true;
      isPaused = false;
    });

    if (isRecording) {
      seconds = 0;
      startTimer();
      await recorder.startRecording();

    }
  }

  void submitVoice() {
    context.go('/sendvoice', extra: filePath);
  }

  void stopTimer() {
    _timer?.cancel();
  }

  String formatTime(int totalSeconds) {
    return "${totalSeconds.toString().padLeft(2, '0')}/${currentMaxSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MicButton(amplitudeStream: recorder.amplitudeStream,isRecording: isRecording, onTap: null),

          const SizedBox(height: 5),

          Text(
            formatTime(seconds),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Divider(color: Colors.white, thickness: 1),
            ),
          ),
          SizedBox(height: 20,),
          Text("Say the Pronounce",style: Theme.of(context).textTheme.displayMedium,),
          SizedBox(height: 20,),
          Text(
            isFirstPhase ? '"AAA"' : '"OOO"',
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Colors.cyanAccent),
          ),
          SizedBox(height: 20,),
          if (!isRecording) Column(children: [const SizedBox(height: 6)]),

          const SizedBox(height: 30),


            Column(
              children: [
                const SizedBox(height: 25),

                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    if (isRecording || doneRecording)
                    Container(
                      height: 60,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isRecording || doneRecording)
                        Container(
                          //cancel
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 187, 70, 72),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: cancelRecording,
                          ),
                        ),

                        const SizedBox(width: 20),

                        //  Pause /  Resume
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isPaused || (!isRecording && !doneRecording))// if not recording and didnt finish recording that means we didnt start recording yet, so the color be red
                                  ? Color.fromARGB(255, 187, 70, 72)
                                  : (!doneRecording
                                        ? Color.fromARGB(255, 34, 75, 68)
                                        : Colors.grey),
                            ),
                            child: IconButton(
                              icon: Icon(
                                (isPaused || doneRecording || !isRecording)
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: Colors.white,
                                size: 80,
                              ),
                              onPressed: doneRecording ? null : toggleRecording,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        //  submit
                        if (isRecording || doneRecording)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: doneRecording ? Colors.cyan : Colors.grey,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: doneRecording
                                ? submitVoice
                                : null, // only enable when the user finishes all the recording
                          ),
                        ),
                      ],
                    ),
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
    recorder.stopRecording();
    _timer?.cancel();
    super.dispose();
  }
}

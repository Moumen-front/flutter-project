import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/mic_button.dart';
import '../services/audio_recorder.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool isRecording = false;
  bool isPaused = false;

  int seconds = 0;
  Timer? _timer;

  // ✅ إنشاء خدمة التسجيل
  final AudioRecorderService recorder = AudioRecorderService();

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  String formatTime(int totalSeconds) {
    final hrs = totalSeconds ~/ 3600;
    final mins = (totalSeconds % 3600) ~/ 60;
    final secs = totalSeconds % 60;

    return '${hrs.toString().padLeft(2, '0')}:'
        '${mins.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Voice Record",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ✅ زر المايك
              MicButton(
                isRecording: isRecording,
                onTap: () async {
                  setState(() {
                    isRecording = !isRecording;
                  });

                  if (isRecording) {
                    seconds = 0;
                    startTimer();

                    // 🔥 بدء التسجيل الحقيقي
                    await recorder.startRecording();

                  } else {
                    stopTimer();

                    // 🔥 إيقاف التسجيل الحقيقي
                    await recorder.stopRecording();
                  }
                },
              ),

              const SizedBox(height: 5),

              if (!isRecording)
                Column(
                  children: [
                    const SizedBox(height: 6),
                    const Icon(Icons.arrow_upward, color: Colors.white, size: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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

              // ⏳ التايمر الديناميكي
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // ❌ Cancel
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.black, size: 28),
                            onPressed: () async {
                              stopTimer();

                              // 🔥 إلغاء التسجيل بدون حفظ
                              await recorder.stopRecording();

                              setState(() {
                                isRecording = false;
                                isPaused = false;
                                seconds = 0;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        // ⏸ Pause / ▶ Resume
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
                            onPressed: () async {
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
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        // 💾 Save
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.check,
                                color: Colors.black, size: 30),
                            onPressed: () async {
                              stopTimer();

                              // 🔥 إيقاف وحفظ الملف
                              final filePath = await recorder.stopRecording();

                              setState(() {
                                isRecording = false;
                                isPaused = false;
                              });

                              // لعرض مسار الملف بعد الحفظ
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Saved: $filePath")),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

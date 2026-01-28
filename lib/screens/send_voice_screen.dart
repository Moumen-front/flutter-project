import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifiers/voice_upload_notifier.dart';

class SendVoiceScreen extends ConsumerStatefulWidget {
  final String wavPath;

  const SendVoiceScreen({super.key, required this.wavPath});

  @override
  ConsumerState<SendVoiceScreen> createState() => _SendVoiceScreenState();
}

class _SendVoiceScreenState extends ConsumerState<SendVoiceScreen> {
  @override
  void initState() {
    super.initState();

    // Start upload
    Future.microtask(() {
      ref.read(voiceUploadProvider.notifier).upload(widget.wavPath);
    });


  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceUploadProvider);
    // Listen for state changes
    ref.listen<AsyncValue<VoiceResponse?>>(
      voiceUploadProvider,
          (previous, next) {
        next.whenOrNull(
          data: (result) {
            if (result == null) return;

            switch (result.status) {
              case JobStatus.uploaded:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Uploaded successfully"),duration: Duration(seconds: 2),),
                );
                ///todo: EID, make the /analysing_screen and the user shouldd be sent to there with the new jobId instead
                context.go('/handwriting'); // test route
                break;

              case JobStatus.failed:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Upload failed, please record and upload again",
                    ),
                    duration: Duration(seconds: 4),
                  ),
                );
                context.go('/voice');
                break;

              case JobStatus.done:
              // handled later
                break;
            }
          },
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Error connecting to the internet",
                ),
                duration: Duration(seconds: 4),
              ),
            );
            context.go('/voice');
          },
        );
      },
    );


    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        body: state.isLoading
            ? const Center(///todo: make the uploading indicator here
          child: CircularProgressIndicator(color: Colors.black),
        )
            : const SizedBox.shrink(), // UI is driven by navigation
      ),
    );
  }
}

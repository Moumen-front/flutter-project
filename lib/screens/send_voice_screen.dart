import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifiers/voice_upload_notifier.dart';
import '../widgets/uploading_loading.dart';

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
              // will be handled later
                break;
            }
          },
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Error occurred, try again",
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
    //  onPopInvokedWithResult: (didPop, _) {if (!didPop) context.go('/');}, //disabled for now so that the user cant go back while uploading, do the same while anylksis is in progress too
      child:  state.isLoading || state.value == null
            ? const Center(
          child: CircularLoadingIndicator(),
        )
            : const SizedBox.shrink(),
    );
  }
}

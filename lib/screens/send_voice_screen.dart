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
              case JobStatus.success:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Analysed successfully"),duration: Duration(seconds: 2),),
                );

                context.go('/results', extra: result);
                break;

              case JobStatus.error:
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(
                      result.message??"Upload failed, please try again later",// if there is no result.message that means the response code isn't 500 so it is another error from the api, 500 means the error from the ai
                    ),
                    duration: Duration(seconds: 4),
                  ),
                );
                context.go('/voice');
                break;
            }
          },
          error: (e, _) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text( //

                  "Error occured, please make sure you are connected to the internet.",
                ),
                duration: Duration(seconds: 4),
              ),
            );
            context.go('/voice');
          },
        );
      },
    );


    return state.isLoading || state.value == null
          ? const Center(
        child: CircularLoadingIndicator(),
      )
          : const SizedBox.shrink();
  }
}

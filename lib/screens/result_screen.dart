
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/voice_upload_notifier.dart';
import '../utils.dart';

class ResultScreen extends ConsumerWidget {
  final VoiceResponse result;
  const ResultScreen({super.key,required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop,_) async{
        if(!didpop)
        {

          await handleBack(context);
        }

      },
      child: Center(
        child: Text(
          result.toString(),
          style: const TextStyle(
            fontSize: 30,
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

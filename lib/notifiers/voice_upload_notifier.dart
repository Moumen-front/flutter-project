import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './../services/api.dart';

enum JobStatus {
  success, // 0
  error, // 1
}

class VoiceResponse {
  final JobStatus status;
  final String? prediction;
  final double? confidence;
  final String? message;

  VoiceResponse({
    required this.status,
    this.prediction,
    this.confidence,
    this.message,
  });

  @override
  String toString() {
    switch (status) {
      case JobStatus.success:
        return "the results are \r\n "
            "Prediction: $prediction \r\n"
            "Confidence: $confidence \r\n";
        break;
      case JobStatus
          .error: // this will not occuire since we will go back to the send voice screen instead of here
        return "error happened \r\n "
            "Error: $message \r\n";
        break;
    }
    return "impossible error";
  }

  factory VoiceResponse.fromJson(Map<String, dynamic> json) {
    return VoiceResponse(
      status: switch (json['status']) {
        'success' => JobStatus.success,
        'error' => JobStatus.error,
        _ => JobStatus.error,
      },
      prediction: json['prediction'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      message: json['message'] as String?,
    );
  }
}

final voiceUploadProvider =
    AsyncNotifierProvider<VoiceUploadNotifier, VoiceResponse?>(
      VoiceUploadNotifier.new,
    );

class VoiceUploadNotifier extends AsyncNotifier<VoiceResponse?> {
  @override
  Future<VoiceResponse?> build() async {
    return null; // idle
  }

  Future<void> upload(String path) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      if (kIsWeb) //for testing only
      {
        return VoiceResponse(
          status: JobStatus.success,
          prediction: "has Parkinson",
          confidence: 0.82,
        );
      }
      final parsedResponse = await Api.sendVoice(path);

      ///it has
      ///final JobStatus status;
      ///final bool? prediction;
      ///final double? confidence;
      ///final String? message;
      ///
      ///

      ///todo: make it return the actual response, i just commented it for testing
      // return parsedResponse;
      return VoiceResponse(
        status: JobStatus.success,
        prediction: "has Parkinson",
        confidence: 0.82,
      );
    });
  }
}

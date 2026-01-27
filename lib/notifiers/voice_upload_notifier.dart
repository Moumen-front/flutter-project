import 'package:flutter_riverpod/flutter_riverpod.dart';
import './../services/api.dart';

enum JobStatus {
  done,      // 0
  uploaded,  // 1
  failed,    // 2
}

class VoiceResponse {
  final JobStatus status;
  final String? jobId;
  final bool? prediction;
  final double? confidence;

  VoiceResponse({
    required this.status,
    this.jobId,
    this.prediction,
    this.confidence,
  });

  factory VoiceResponse.fromJson(Map<String, dynamic> json) {
    return VoiceResponse(
      status: switch (json['status']) {
        'done' => JobStatus.done,
        'uploaded' => JobStatus.uploaded,
        'failed' => JobStatus.failed,
        _ => JobStatus.failed,
      },
      jobId: json['jobId'] as String?,
      prediction: json['prediction'] as bool?,
      confidence: (json['confidence'] as num?)?.toDouble(),
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
      final parsedResponse = await Api.sendVoice(path);

      ///it has
      ///final JobStatus status;
      ///final String? jobId;
      ///final bool? prediction;
      ///final double? confidence;
      ///
      ///


      return parsedResponse;
    });
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../notifiers/voice_upload_notifier.dart';

class Api {
  static const _baseurl = "https://webhook.site/43a0b4e2-e2c1-485f-a065-b7de975d4c8c";

  static Future<VoiceResponse> sendVoice(String path) async {
    final wavFile = File(path);

    final wavBytes = await wavFile.readAsBytes();

    final uri = Uri.parse(_baseurl);
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'voice', // field name expected by the API
        wavBytes,
        filename: path
            .split('/')
            .last, //as example: my_record.wav
        contentType: http.MediaType('audio', 'wav'),
      ),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200 && streamedResponse.statusCode != 500) {
      return VoiceResponse(
        status: JobStatus.error,
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(responseBody) as Map<String, dynamic>;

    return VoiceResponse.fromJson(json);
  }
}
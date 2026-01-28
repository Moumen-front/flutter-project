import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../notifiers/voice_upload_notifier.dart';

class Api {
  static const _baseurl = "https://webhook.site/eb958402-86d6-40be-95fb-d6076dc3ed47";

  static Future<VoiceResponse> sendVoice(String path) async {
    final wavFile = File(path);

    final wavBytes = await wavFile.readAsBytes();

    final uri = Uri.parse(_baseurl);
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file', // field name expected by the API
        wavBytes,
        filename: path
            .split('/')
            .last, //as example: my_record.wav
        contentType: http.MediaType('audio', 'wav'),
      ),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      return VoiceResponse(
        status: JobStatus.failed,
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(responseBody) as Map<String, dynamic>;

    return VoiceResponse.fromJson(json);
  }
}
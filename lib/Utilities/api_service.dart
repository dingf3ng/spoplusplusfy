import 'package:dio/dio.dart';
import 'dart:io';

import 'package:spoplusplusfy/Classes/song.dart';

const fhlIP = '10.211.55.5:8000';
const dfIP = '192.168.2.169';
const local = '10.0.2.2';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'http://$fhlIP'; // Replace with your backend URL
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<void> uploadVideo({
    required String filePath,
    required String token,
    required String title,
    required String description,
    required int songId,
    required File coverImage,
    required int duration,
    required int userId,
  }) async {
    try {
      String fileName = filePath.split('/').last;
      String coverImageName = coverImage.path.split('/').last;

      FormData formData = FormData.fromMap({
        'video_file': await MultipartFile.fromFile(filePath, filename: fileName),
        'title': title,
        'description': description,
        'song': songId,
        'cover_image': await MultipartFile.fromFile(coverImage.path, filename: coverImageName),
        'duration': duration,
        'user': userId,
      });

      _dio.options.headers['Authorization'] = 'Token $token';

      Response response = await _dio.post('/api/videos/', data: formData);

      if (response.statusCode == 201) {
        print('Video uploaded successfully');
      } else {
        print('Failed to upload video');
      }
    } catch (e) {
      print('Error uploading video: $e');
    }
  }
}

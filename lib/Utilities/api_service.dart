import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:spoplusplusfy/Classes/song.dart';

const fhlIP = '10.211.55.5';
const dfIP = '192.168.2.169';
const local = '10.0.2.2';

class ApiService {
  final Dio _dio = Dio();
  static ApiService? apiService;

  /// Constructor to initialize Dio with base URL and default headers.
  ///
  /// The base URL is set to 'http://$fhlIP' and the 'Content-Type' header is set to 'application/json'.
  ApiService() {
    _dio.options.baseUrl = 'http://$fhlIP'; // Replace with your backend URL
    _dio.options.headers['Content-Type'] = 'application/json';
  }



  /// Uploads a video file along with metadata to the backend.
  ///
  /// Parameters:
  /// - [filePath]: The path to the video file.
  /// - [token]: The authentication token.
  /// - [title]: The title of the video.
  /// - [description]: The description of the video.
  /// - [songId]: The ID of the associated song.
  /// - [coverImage]: The cover image file.
  /// - [duration]: The duration of the video in seconds.
  /// - [userId]: The ID of the user uploading the video.
  ///
  /// Throws an error if the upload fails.
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
      // Extracting file names from paths
      String fileName = filePath.split('/').last;
      String coverImageName = coverImage.path.split('/').last;

      // Creating FormData to send the data in multipart format
      FormData formData = FormData.fromMap({
        'video_file': await MultipartFile.fromFile(filePath, filename: fileName),
        'title': title,
        'description': description,
        'song': songId,
        'cover_image': await MultipartFile.fromFile(coverImage.path, filename: coverImageName),
        'duration': duration,
        'user': userId,
      });

      // Adding authorization token to the headers
      _dio.options.headers['Authorization'] = 'Token $token';

      // Sending POST request to upload the video
      Response response = await _dio.post('/api/videos/', data: formData);

      // Checking response status code
      if (response.statusCode == 201) {
        print('Video uploaded successfully');
      } else {
        print('Failed to upload video');
      }
    } catch (e) {
      // Handling and printing any errors that occur during the upload
      print('Error uploading video: $e');
    }
  }

  Future<http.Response> login({required String email, required String password}) {
    var response = http.post(Uri.parse('http://$fhlIP/api/auth/login'),
        headers: {
          'Content-Type' : 'application/json',
        },
        body: jsonEncode(<String, String> {
          'email': email,
          'password' : password,
        }));
    return response;

  }

}

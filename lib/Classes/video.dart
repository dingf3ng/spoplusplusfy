import 'dart:convert';

import 'package:spoplusplusfy/Classes/person.dart';
import 'package:video_player/video_player.dart';

class Video {
  int id;
  int userId;
  int songId;
  String videoTitle;
  String songName;
  int likes;
  int comments;
  String videoFileUrl;
  String coverImageUrl;
  final DateTime createdAt;

  VideoPlayerController? controller;

  Video(
  {
    required this.id,
    required this.userId,
    required this.songId,
    required this.videoTitle,
    required this.songName,
    required this.likes,
    required this.comments,
    required this.videoFileUrl,
    required this.coverImageUrl,
    required this.createdAt
});

  Future<void> loadController() async {
    // TODO: fill in the URL
    controller = VideoPlayerController.networkUrl(
        Uri.http('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'));
    await controller?.initialize();
    controller?.setLooping(true);
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(id: json['id'],
        userId: json['user'],
        videoTitle: json['title'],
        songName: json['song']['name'],
        likes: json['likes_count'],
        comments: json['comments'].length,
        videoFileUrl: json['video_file'],
        coverImageUrl: json['cover_image'],
        songId: json['song']['id'],
        createdAt: DateTime.parse(json['created_at']));
  }

  String getUrl() {
    return videoFileUrl;
  }
}
import 'dart:convert';

import 'package:spoplusplusfy/Classes/person.dart';
import 'package:video_player/video_player.dart';

/// Represents a video in the application.
///
/// This class encapsulates all the metadata and functionality related to a video,
/// including its associated song, user information, and playback capabilities.
class Video {
  /// Unique identifier for the video.
  int id;

  /// ID of the user who created the video.
  int userId;

  /// ID of the song associated with the video.
  int songId;

  /// Title of the video.
  String videoTitle;

  /// Name of the song associated with the video.
  String songName;

  /// Number of likes the video has received.
  int likes;

  /// Number of comments on the video.
  int comments;

  /// URL of the video file.
  String videoFileUrl;

  /// URL of the video's cover image.
  String coverImageUrl;

  /// Date and time when the video was created.
  final DateTime createdAt;

  /// Controller for video playback.
  VideoPlayerController? controller;

  /// Creates a [Video] instance.
  ///
  /// All parameters are required to fully define a video's metadata.
  Video({
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

  /// Initializes the video player controller.
  ///
  /// This method sets up the [VideoPlayerController] with a hardcoded URL.
  /// TODO: Replace the hardcoded URL with the actual video URL.
  Future<void> loadController() async {
    controller = VideoPlayerController.networkUrl(
        Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'));
    await controller?.initialize();
    controller?.setLooping(true);
  }

  /// Creates a [Video] instance from a JSON map.
  ///
  /// This factory method parses a JSON object to create a new [Video] instance.
  ///
  /// Parameters:
  /// - [json]: A map containing the video's data in JSON format.
  ///
  /// Returns a new [Video] instance.
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
        id: json['id'],
        userId: json['user'],
        videoTitle: json['title'],
        songName: json['song']['name'],
        likes: json['likes_count'],
        comments: json['comments'].length,
        videoFileUrl: json['video_file'],
        coverImageUrl: json['cover_image'],
        songId: json['song']['id'],
        createdAt: DateTime.parse(json['created_at'])
    );
  }

  /// Gets the URL of the video file.
  ///
  /// Returns the [videoFileUrl] as a [String].
  String getUrl() {
    return videoFileUrl;
  }
}
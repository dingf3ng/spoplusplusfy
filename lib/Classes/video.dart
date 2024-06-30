import 'package:spoplusplusfy/Classes/person.dart';
import 'package:video_player/video_player.dart';

class Video {
  int id;
  Person user;
  String videoTitle;
  String songName;
  int likes;
  int comments;
  String url;

  VideoPlayerController? controller;

  Video(
  {
    required this.id,
    required this.user,
    required this.videoTitle,
    required this.songName,
    required this.likes,
    required this.comments,
    required this.url
});

  Future<void> loadController() async {
    // TODO: fill in the URL
    controller = VideoPlayerController.networkUrl(
        Uri.http('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'));
    await controller?.initialize();
    controller?.setLooping(true);
  }

  String getUrl() {
    return url;
  }
}
import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/single_video_page.dart';

import '../Classes/video.dart';


class SocialModePlayerPage extends StatelessWidget {
  final List<Video> videos = [
    Video(id: 0, user: NormalUser(name: 't', id: 1, gender: Gender.Male, portrait: Image.asset('assets/images/pf.jpg'), age: 13), videoTitle: 'test', songName: 'test', likes: 1, comments: 1, url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',),
    Video(id: 0, user: NormalUser(name: 't', id: 1, gender: Gender.Male, portrait: Image.asset('assets/images/pf.jpg'), age: 13), videoTitle: 'test', songName: 'test', likes: 1, comments: 1, url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', ),
  ];
  final pageController = PageController(initialPage: 999);

  SocialModePlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return SingleVideoPage(video: videos[index % videos.length]);
        },
      ),
    );
  }
}

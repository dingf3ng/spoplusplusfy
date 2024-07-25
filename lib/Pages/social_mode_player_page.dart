import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/single_video_page.dart';

import '../Classes/video.dart';

class SocialModePlayerPage extends StatelessWidget {
  final List<Video> videos;
  final pageController = PageController(initialPage: 999);
  int index = 0;

  SocialModePlayerPage(this.videos, this.index, {super.key});

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

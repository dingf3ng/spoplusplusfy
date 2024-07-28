import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/single_video_page.dart';
import '../Classes/video.dart';

/// A stateless widget that displays a list of videos in a vertical PageView.
/// The user can scroll through videos, and each video occupies a full page.
class SocialModePlayerPage extends StatelessWidget {
  final List<Video> videos;
  final PageController pageController;
  final int initialIndex;

  /// Creates a SocialModePlayerPage.
  ///
  /// The [videos] parameter is required and must not be null.
  /// The [initialIndex] parameter is used to set the initial page in the PageView.
  SocialModePlayerPage(this.videos, this.initialIndex, {super.key})
      : pageController = PageController(initialPage: initialIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          // Use modulus to ensure the index stays within bounds of the videos list.
          return SingleVideoPage(video: videos[index % videos.length]);
        },
      ),
    );
  }
}

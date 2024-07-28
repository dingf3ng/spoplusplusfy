import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../Classes/video.dart';

/// A StatefulWidget that displays a single video page with play/pause controls,
/// like, comment, and share buttons.
class SingleVideoPage extends StatefulWidget {
  final Video video;

  /// Creates a SingleVideoPage.
  ///
  /// The [video] parameter is required and must not be null.
  const SingleVideoPage({super.key, required this.video});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<SingleVideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller with the video URL.
    // Note: This part may need modification based on the actual URL format.
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.getUrl()));

    // Initialize the video player and start playing the video when ready.
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });

    // Set the video to loop indefinitely.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Dispose the video player controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Center(
                // Display the video player with correct aspect ratio.
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              // Display a play button if the video is paused.
              if (!_controller.value.isPlaying)
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/music_pause_black.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
              // GestureDetector to toggle play/pause on video tap.
              SizedBox.expand(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
              ),
              // Buttons for like, comment, and share actions.
              Positioned(
                right: 20,
                top: MediaQuery.of(context).size.height / 2 - 50,
                child: Column(
                  children: [
                    _likeButton(),
                    const SizedBox(height: 60),
                    _commentButton(),
                    const SizedBox(height: 60),
                    _shareButton(),
                  ],
                ),
              ),
              // User information and follow button at the bottom.
              Positioned(
                bottom: 20,
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    CircleAvatar(
                      backgroundImage: Image.asset('assets/images/pf.jpg').image,
                      radius: 40,
                    ),
                    const SizedBox(width: 30),
                    Text(
                      'Name',
                      style: TextStyle(
                        color: secondaryColor,
                        fontFamily: 'NotoSans',
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: 90,
                      height: 50,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: const Center(
                        child: Text(
                          'follow',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Show a loading indicator while the video is being initialized.
          return Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        }
      },
    );
  }

  /// Widget for the share button with SVG icon.
  SvgPicture _shareButton() => SvgPicture.asset(
    'assets/icons/share_gold.svg',
    width: 80,
    height: 80,
  );

  /// Widget for the comment button with a modal bottom sheet for comments.
  Widget _commentButton() => GestureDetector(
    child: SvgPicture.asset(
      'assets/icons/comment_gold.svg',
      width: 80,
      height: 80,
    ),
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: const Text(
              'Nobody has commented yet. Leave a comment below!',
              style: TextStyle(fontSize: 35),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    },
  );

  /// Widget for the like button with SVG icon.
  SvgPicture _likeButton() => SvgPicture.asset(
    'assets/icons/like_gold.svg',
    width: 80,
    height: 80,
  );
}

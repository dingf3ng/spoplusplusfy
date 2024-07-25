import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../Classes/video.dart';
//TODO: video should fit entire screen or go to the centre.

class SingleVideoPage extends StatefulWidget {
  final Video video;

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
    // TODO: this needs modification
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.getUrl()));

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });

    _controller.setLooping(true);
  }

  @override
  void dispose() {
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
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              if (!_controller.value.isPlaying)
                Center(
                    child: SvgPicture.asset(
                  'assets/icons/music_pause_black.svg',
                  width: 80,
                  height: 80,
                )),
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
              Positioned(
                right: 20,
                top: MediaQuery.of(context).size.height / 2 - 50,
                child: Column(
                  children: [
                    _likeButton(),
                    const SizedBox(
                      height: 60,
                    ),
                    _commentButton(),
                    const SizedBox(
                      height: 60,
                    ),
                    _shareButton(),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          Image.asset('assets/images/pf.jpg').image,
                      radius: 40,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Name',
                      style: TextStyle(
                          color: secondaryColor,
                          fontFamily: 'NotoSans',
                          fontSize: 40),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 90,
                      height: 50,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(3.0)),
                      child: const Center(
                          child: Text(
                        'follow',
                        style: TextStyle(fontSize: 20),
                      )),
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          ));
        }
      },
    );
  }

  SvgPicture _shareButton() => SvgPicture.asset(
        'assets/icons/share_gold.svg',
        width: 80,
        height: 80,
      );

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
            });
      });

  SvgPicture _likeButton() => SvgPicture.asset(
        'assets/icons/like_gold.svg',
        width: 80,
        height: 80,
      );
}

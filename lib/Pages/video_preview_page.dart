import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Pages/user_page.dart';
import 'package:spoplusplusfy/Utilities/api_service.dart';
import 'package:video_player/video_player.dart';
import '../Classes/person.dart';
import '../Classes/song.dart'; // Import the Song class
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';


class VideoPreviewPage extends StatefulWidget {
  final File videoFile;
  final Song song;
  final NormalUser user;

  VideoPreviewPage({required this.videoFile, required this.song, required this.user});

  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  File? _coverImageFile;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _uploadVideo({required String filePath, required String token,
    required String title, required String description,
    required int songId, required File coverImage,
    required int duration, required int userId}) async {
      ApiService().uploadVideo(
          filePath: filePath,
          token: token,
          title: title,
          description: description,
          songId: songId,
          coverImage: coverImage,
          duration: duration,
          userId: userId);
    print("Video uploaded successfully");
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload Video"),
          content: Text("Do you want to upload this video?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () async {
                await _loadCoverImage();
                Navigator.of(context).pop();
                _uploadVideo(
                    filePath: widget.videoFile.path,
                    token: (await SharedPreferences.getInstance()).getString('token')!,
                    title: 'Default Title',
                    description: 'Default Description',
                    songId: widget.song.getId(),
                    coverImage: _coverImageFile!,
                    duration: 60,
                    userId: widget.user.getId(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Video"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _showUploadDialog,
          ),
        ],
      ),
      body: _controller.value.isInitialized
          ? Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: VideoPlayer(_controller),
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(color: UserPageState.secondaryColor,),
      ),
    );
  }

  Future<void> _loadCoverImage() async {
    final ByteData data = await rootBundle.load('assets/images/pf.jpg');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/cover_image.jpg');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    setState(() {
      _coverImageFile = tempFile;
    });
  }

}

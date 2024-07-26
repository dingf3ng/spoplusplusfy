import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

import '../Classes/song.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Preview Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoUploadPage(),
    );
  }
}

class VideoUploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Video"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPreviewPage(),
              ),
            );
          },
          child: Text("Go to Video Preview"),
        ),
      ),
    );
  }
}

class VideoPreviewPage extends StatefulWidget {
  final Song song;
  VideoPreviewPage({super.key, required this.song})
  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isVideoSelected = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    if (await _requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      if (result != null && result.files.single.path != null) {
        _controller = VideoPlayerController.file(File(result.files.single.path!))
          ..initialize().then((_) {
            setState(() {
              _isVideoSelected = true;
            });
            _controller!.play();
            _isPlaying = true;
          });
      }
    } else {
      _showPermissionDeniedMessage();
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      if (Platform.isAndroid && await Permission.videos.request().isGranted && await Permission.photos.request().isGranted) {
        return true;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permission denied to read external storage')),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller?.pause();
      } else {
        _controller?.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _uploadVideo() async {
    // Implement your upload logic here
    // You can use HTTP package or any other package to upload the video file
    // For now, we'll just print a message
    print("Video uploaded successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview Video"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _isVideoSelected
              ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
              : Container(
            height: 200,
            color: Colors.black,
            child: Center(
              child: Text(
                "No video selected",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          _isVideoSelected
              ? Column(
            children: [
              VideoProgressIndicator(_controller!, allowScrubbing: true),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: _togglePlayPause,
              ),
              ElevatedButton(
                onPressed: _uploadVideo,
                child: Text("Upload Video"),
              ),
            ],
          )
              : ElevatedButton(
            onPressed: _pickVideo,
            child: Text("Choose Video"),
          ),
        ],
      ),
    );
  }
}

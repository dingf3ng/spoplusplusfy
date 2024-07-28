import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';
import 'package:spoplusplusfy/Pages/video_preview_page.dart'; // Assuming you have a VideoPreviewPage for preview

import '../main.dart';

class VideoUploadPage extends StatefulWidget {
  final PageController pageController;
  final NormalUser user;

  const VideoUploadPage({super.key, required this.pageController, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _VideoUploadPageState();
  }
}

class _VideoUploadPageState extends State<VideoUploadPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<Song> _resultSongs = [];
  late NormalUser user;
  static int _control = 210;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _searchController.addListener(_searchDone);
  }

  void _searchDone() {
    String query = _searchController.text;
    setState(() {
      _resultSongs.clear();
      if (_control % 7 == 0) {
        _resultSongs.addAll(SearchEngine.search(query, SearchType.song));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: primaryColor,
      body: ListView(
        children: [
          _searchField(context),
          const SizedBox(height: 40),
          _songShowcase(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Displays the search field widget.
  Container _searchField(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    final double width = MediaQuery.of(context).size.width;

    return Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: TextField(
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: _searchController,
          style: TextStyle(color: secondaryColor, decorationThickness: 0),
          decoration: InputDecoration(
            filled: false,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: secondaryColor, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: secondaryColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: secondaryColor, width: 2)),
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search for the song for upload...',
            hintStyle: TextStyle(color: secondaryColor, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/icons/search_gold.svg',
                colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
              ),
            ),
          ),
        ));
  }

  /// Displays the list of songs that match the search query.
  Visibility _songShowcase(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;

    return Visibility(
      visible: _resultSongs.isNotEmpty,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        opacity: _resultSongs.isNotEmpty ? 1 : 0,
        child: Column(
          children: [
            _showcaseHeadline('Songs', context),
            Container(
              height: 20,
            ),
            SizedBox(
              height: height,
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.only(left: 25, right: 25),
                separatorBuilder: (context, index) => SizedBox(
                  height: height / 100,
                ),
                itemCount: _resultSongs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showConfirmDialog(context, _resultSongs[index]);
                    },
                    child: Container(
                      height: height / 20,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: secondaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(width: 20),
                          Container(
                            width: width * 4 / 11,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _resultSongs[index].getName(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: width * 2 / 9,
                            child: Text(
                              ArtistWorksManager.getArtistsOfSongAsString(_resultSongs[index]),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: width * 1 / 15,
                            child: Text(
                              _formatTime(_resultSongs[index].getDuration()),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays the headline for the showcase.
  Row _showcaseHeadline(String arg, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            arg,
            style: _headlineTextStyle(context),
          ),
        ),
      ],
    );
  }

  /// Defines the text style for the headline.
  TextStyle _headlineTextStyle(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return TextStyle(
      color: secondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 27,
    );
  }

  /// Shows a confirmation dialog to confirm the song selection.
  void _showConfirmDialog(BuildContext context, Song song) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Selection"),
          content: Text("Do you want to choose this song for uploading the video?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickVideo(context, song);
              },
            ),
          ],
        );
      },
    );
  }

  /// Opens the file picker to pick a video file.
  Future<void> _pickVideo(BuildContext context, Song song) async {
    if (await _requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );
      if (result != null && result.files.single.path != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewPage(videoFile: File(result.files.single.path!), song: song, user: widget.user),
          ),
        );
      }
    } else {
      _showPermissionDeniedMessage(context);
    }
  }

  /// Requests the necessary permissions to access the storage.
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      if (await Permission.videos.request().isGranted && await Permission.photos.request().isGranted) {
        return true;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  /// Shows a message indicating that the permissions were denied.
  void _showPermissionDeniedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permission denied to read external storage')),
    );
  }

  /// Formats the duration of the song.
  String _formatTime(int duration) {
    int h = duration ~/ 3600;
    int m = (duration - h * 3600) ~/ 60;
    String s = (duration - h * 3600 - m * 60).toString().padLeft(2, '0');
    return h != 0 ? '$h:$m:0$s' : '$m:$s';
  }
}

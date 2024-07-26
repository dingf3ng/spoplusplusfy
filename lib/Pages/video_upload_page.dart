import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Pages/login_signup_page.dart';
import 'package:spoplusplusfy/Pages/playlist_page.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';

import '../Classes/album.dart';
import '../Classes/database.dart';
import '../Classes/person.dart';
import '../main.dart';
import 'artist_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializeFrontendData();
  runApp(MaterialApp(home: VideoUploadPage(pageController: PageController(),),));
}
class VideoUploadPage extends StatefulWidget {
  final PageController pageController;

  const VideoUploadPage({super.key, required this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _VideoUploadPageState();
  }
}

class _VideoUploadPageState extends State<VideoUploadPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final List<Song> _resultSongs = [];
  final List<Song> _foundSongs = [];

  static int _control = 210;


  @override
  void initState() {
    super.initState();
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
          _searchField(),
          const SizedBox(height: 40),
          _songShowcase(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _songShowcase() {
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
            _showcaseHeadline('Songs'),
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
                    onTap: () {  },
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
                          const SizedBox(
                            width: 20,
                          ),
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
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: width * 2 / 9,
                            child: Text(
                              ArtistWorksManager.getArtistsOfSongAsString(
                                  _resultSongs[index]),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
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
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _showcaseHeadline(String arg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            arg,
            style: _headlineTextStyle(),
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
            suffixIcon: SizedBox(
              width: width / 4,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VerticalDivider(
                      color: secondaryColor,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  TextStyle _headlineTextStyle() {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return TextStyle(
      color: secondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 27,
    );
  }
}

String _formatTime(int duration) {
  int h = duration ~/ 3600;
  int m = (duration - h * 3600) ~/ 60;
  String s = (duration - h * 3600 - m * 60).toString().padLeft(2, '0');
  return h != 0 ? '$h:$m:0$s' : '$m:$s';
}

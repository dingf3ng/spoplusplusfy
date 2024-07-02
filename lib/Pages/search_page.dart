import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Pages/login_signup_page.dart';
import 'package:spoplusplusfy/Pages/playlist_page.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';

import '../Classes/album.dart';
import 'artist_page.dart';

class SearchPage extends StatefulWidget {
  final PageController pageController;

  const SearchPage({super.key, required this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  final List<Artist> _resultArtists = [];
  final List<Album> _resultAlbums = [];
  final List<CustomizedPlaylist> _resultPlaylists = [];
  final List<Song> _resultSongs = [];

  final ScrollController _controller = ScrollController();

  _scrollListener() async {
    ScrollPosition position = _controller.position;
    if (_controller.offset == position.maxScrollExtent) {
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    } else if (_controller.offset == position.minScrollExtent) {
      widget.pageController.previousPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchDone);
    _controller.addListener(_scrollListener);
  }

  void _searchDone() {
    String query = _searchController.text;
    setState(() {
      _resultArtists.clear();
      _resultAlbums.clear();
      _resultPlaylists.clear();
      _resultSongs.clear();
      _resultArtists
          .addAll(SearchEngine.search<Artist>(query, SearchType.artist).cast());
      _resultAlbums.addAll(SearchEngine.search<Album>(query, SearchType.album));
      _resultPlaylists.addAll(
          SearchEngine.search<CustomizedPlaylist>(query, SearchType.playlist));
      _resultSongs.addAll(SearchEngine.search(query, SearchType.song));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: primaryColor,
      appBar: _appBar(),
      body: ListView(
        children: [
          _searchField(),
          const SizedBox(height: 40),
          _artistShowcase(),
          _albumShowcase(),
          _playlistShowcase(),
          _songShowcase(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _artistShowcase() {
    return Visibility(
      visible: _resultArtists.isNotEmpty,
      child: Column(
        children: [
          _showcaseHeadline('Artists'),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              ),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: _resultArtists.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArtistPage(
                                  artist: _resultArtists[index],
                                ))),
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          border: Border.all(color: secondaryColor, width: 3),
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: ClipOval(
                          child: _resultArtists[index].getPortrait(),
                        ),
                      ),
                      Container(
                        width: 90,
                        alignment: Alignment.center,
                        child: Text(
                          _resultArtists[index].getName(),
                          style: const TextStyle(
                            color: secondaryColor,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _albumShowcase() {
    return Visibility(
      visible: _resultAlbums.isNotEmpty,
      child: Column(
        children: [
          _showcaseHeadline('Albums'),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              ),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: _resultAlbums.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaylistPage(
                                playlist: _resultAlbums[index],
                                songs: PlaylistSongManager.getSongsForPlaylist(
                                    _resultAlbums[index]))))
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: secondaryColor,
                              width: 3,
                            ),
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                  _resultAlbums[index].getCoverPath()),
                              fit: BoxFit.cover,
                            )),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 140,
                        child: Text(
                          _resultAlbums[index].getName(),
                          style: const TextStyle(
                            color: secondaryColor,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _playlistShowcase() {
    return Visibility(
      visible: _resultPlaylists.isNotEmpty,
      child: Column(
        children: [
          _showcaseHeadline('Playlists'),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              ),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: _resultPlaylists.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          border: Border.all(
                            color: secondaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(
                                _resultPlaylists[index].getCoverPath()),
                          )),
                    ),
                    Container(
                      width: 140,
                      alignment: Alignment.center,
                      child: Text(
                        _resultPlaylists[index].getName(),
                        style: const TextStyle(
                          color: secondaryColor,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _songShowcase() {
    return Visibility(
      visible: _resultSongs.isNotEmpty,
      child: Column(
        children: [
          _showcaseHeadline('Songs'),
          Container(
            height: 20,
          ),
          SizedBox(
            height: 350,
            child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(left: 25, right: 25),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: _resultSongs.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: secondaryColor, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 170,
                        child: Text(
                          _resultSongs[index].getName(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          ArtistWorksManager.getArtistsOfSongAsString(
                              _resultSongs[index]),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          _formatTime(_resultSongs[index].getDuration()),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
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

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 90,
      backgroundColor: primaryColor,
      leading: GestureDetector(
        onTap: () {},
        child: FittedBox(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
              child: SvgPicture.asset('assets/icons/setting_gold.svg'),
            )),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SignupPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, -1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(seconds: 1)
                  ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'UserName ',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: secondaryColor,
                ),
              ),
              SvgPicture.asset('assets/icons/user_gold.svg',
                  height: 32, width: 32)
            ],
          ),
        ),
        Container(
          width: 20,
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: TextField(
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: _searchController,
          style: const TextStyle(color: secondaryColor, decorationThickness: 0),
          decoration: InputDecoration(
            filled: false,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: secondaryColor, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: secondaryColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: secondaryColor, width: 2)),
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Color(0xffffE8A3), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/search_gold.svg'),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Color(0xffFFE8A3),
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 12, 12, 12),
                      child: SvgPicture.asset(
                          'assets/icons/filter_search_gold.svg'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  TextStyle _headlineTextStyle() {
    return const TextStyle(
      color: secondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );
  }
}

String _formatTime(int duration) {
  int h = duration ~/ 3600;
  int m = (duration - h * 3600) ~/ 60;
  int s = (duration - h * 3600 - m * 60);
  return h != 0 ? '$h:$m:$s' : '$m:$s';
}

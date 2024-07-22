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
import '../main.dart';
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

  final List<Artist> _resultArtists = [];
  final List<Album> _resultAlbums = [];
  final List<CustomizedPlaylist> _resultPlaylists = [];
  final List<Song> _resultSongs = [];
  final List<Song> _foundSongs = [];

  static int _control = 210;

  void _openFilter() {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height / 4;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Container(
              width: width,
              height: MediaQuery.of(context).size.height * 3 / 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width / 15),
                    topRight: Radius.circular(width / 15)),
                color: Colors.black,
                border: Border(
                    left: BorderSide(color: secondaryColor, width: 2),
                    right: BorderSide(color: secondaryColor, width: 2),
                    top: BorderSide(color: secondaryColor, width: 2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Search Filter',
                      style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                  ),
                  _buildCheckBox(context, 'Artists', height, 2, setSheetState),
                  _buildCheckBox(context, 'Albums', height, 3, setSheetState),
                  _buildCheckBox(
                      context, 'Playlists', height, 5, setSheetState),
                  _buildCheckBox(context, 'Songs', height, 7, setSheetState),
                  ElevatedButton(
                      onPressed: () {
                        _control = 210;
                        setSheetState(() {
                          _searchDone();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          maximumSize: Size(width / 2, height)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: width / 20,
                            width: width / 20,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/reset_gold.svg',
                              colorFilter: ColorFilter.mode(
                                  secondaryColor, BlendMode.srcIn),
                            ),
                          ),
                          SizedBox(
                            width: width / 20,
                          ),
                          const Text(
                            'Reset Filter',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                        ],
                      ))
                ],
              ),
            );
          });
        });
  }

  Widget _buildCheckBox(context, title, height, int control, setter) {
    var width = MediaQuery.of(context).size.width;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return Row(
      children: [
        SizedBox(
          width: 25,
          height: height / 10,
        ),
        GestureDetector(
          onTap: () {
            _control = _control % control == 0
                ? _control ~/ control
                : _control * control;
            setter(() {
              _searchDone();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              height: height / 5,
              width: width / 7,
              child: Visibility(
                visible: _control % control == 0,
                child: SvgPicture.asset(
                  'assets/icons/checkmark_gold.svg',
                  colorFilter:
                      ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            height: height / 5,
            width: width * 5 / 7,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 22),
            )),
      ],
    );
  }

  void _openRecognizer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height / 4;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Container(
              width: width,
              height: MediaQuery.of(context).size.height * 3 / 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width / 15),
                    topRight: Radius.circular(width / 15)),
                color: Colors.black,
                border: Border(
                    left: BorderSide(color: secondaryColor, width: 2),
                    right: BorderSide(color: secondaryColor, width: 2),
                    top: BorderSide(color: secondaryColor, width: 2)),
              ),
              child: Column(
                children: [
                  Container(
                    height: height / 4,
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Finder',
                      style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: height * 1.45,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            height: height / 5,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(color: secondaryColor, width: 2),
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
                                    _formatTime(
                                        _resultSongs[index].getDuration()),
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
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: _resultSongs.length),
                  )
                ],
              ),
            );
          });
        });
  }

  Future _showSettingDialog(context) {
    var width = MediaQuery.of(context).size.width * 3 / 4;
    var height = MediaQuery.of(context).size.height / 3;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Settings')),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width / 10),
              side: BorderSide(color: secondaryColor, width: 2.0),
            ),
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(
                color: secondaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w600),
            content: SizedBox(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Color Theme',
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: Container(
                      height: height / 9,
                      width: width,
                      alignment: Alignment.center,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                themeNotifier.changeTheme(true, index);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width / 10),
                                    border: Border.all(
                                        color: secondaryColor, width: 2),
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor,
                                        secondaryColorList[index]
                                      ],
                                      stops: const [0.3, 0.6],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                height: height / 9,
                                width: width / 4,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 10,
                              ),
                          itemCount: 7),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchDone);
  }

  void _searchDone() {
    String query = _searchController.text;
    setState(() {
      _resultArtists.clear();
      _resultAlbums.clear();
      _resultPlaylists.clear();
      _resultSongs.clear();
      if (_control % 2 == 0) {
        _resultArtists.addAll(
            SearchEngine.search<Artist>(query, SearchType.artist).cast());
      }
      if (_control % 3 == 0) {
        _resultAlbums
            .addAll(SearchEngine.search<Album>(query, SearchType.album));
      }
      if (_control % 5 == 0) {
        _resultPlaylists.addAll(SearchEngine.search<CustomizedPlaylist>(
            query, SearchType.playlist));
      }
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return Visibility(
      visible: _resultArtists.isNotEmpty,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        opacity: _resultArtists.isNotEmpty ? 1 : 0,
        child: Column(
          children: [
            _showcaseHeadline('Artists'),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: width * 2 / 9 + 30,
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
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ArtistPage(artist: _resultArtists[index]),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                            transitionDuration: const Duration(seconds: 1),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 600),
                          )),
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width * 2 / 9,
                          height: width * 2 / 9,
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
                          width: width * 2 / 9,
                          alignment: Alignment.center,
                          child: Text(
                            _resultArtists[index].getName(),
                            style: TextStyle(
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
      ),
    );
  }

  Visibility _albumShowcase() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return Visibility(
      visible: _resultAlbums.isNotEmpty,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        opacity: _resultAlbums.isNotEmpty ? 1 : 0,
        child: Column(
          children: [
            _showcaseHeadline('Albums'),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: width / 3 + 30,
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
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                PlaylistPage(
                                    playlist: _resultAlbums[index],
                                    songs:
                                        PlaylistSongManager.getSongsForPlaylist(
                                            _resultAlbums[index])),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                            transitionDuration: const Duration(seconds: 1),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 600),
                          ))
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width / 3,
                          height: width / 3,
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
                          width: width / 3,
                          child: Text(
                            _resultAlbums[index].getName(),
                            style: TextStyle(
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
      ),
    );
  }

  Visibility _playlistShowcase() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return Visibility(
      visible: _resultPlaylists.isNotEmpty,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        opacity: _resultPlaylists.isNotEmpty ? 1 : 0,
        child: Column(
          children: [
            _showcaseHeadline('Playlists'),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: width / 3 + 30,
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
                        width: width / 3,
                        height: width / 3,
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
                        width: width / 3,
                        alignment: Alignment.center,
                        child: Text(
                          _resultPlaylists[index].getName(),
                          style: TextStyle(
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
              height: height / 3,
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.only(left: 25, right: 25),
                separatorBuilder: (context, index) => SizedBox(
                  height: height / 100,
                ),
                itemCount: _resultSongs.length,
                itemBuilder: (context, index) {
                  return Container(
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

  AppBar _appBar() {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return AppBar(
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 90,
      backgroundColor: primaryColor,
      leading: GestureDetector(
        onTap: () {
          _showSettingDialog(context);
        },
        child: FittedBox(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
              child: SvgPicture.asset(
                'assets/icons/setting_gold.svg',
                colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
              ),
            )),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LoginPage(),
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
                transitionDuration: const Duration(seconds: 1),
                reverseTransitionDuration: const Duration(milliseconds: 600),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UserName ',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: secondaryColor,
                ),
              ),
              SvgPicture.asset('assets/icons/user_gold.svg',
                  colorFilter:
                      ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                  height: 32,
                  width: 32)
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
            hintText: 'Search...',
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
                    GestureDetector(
                      onTap: () => {_openRecognizer()},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
                        child: SvgPicture.asset(
                          'assets/icons/ear_gold.svg',
                          colorFilter:
                              ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: secondaryColor,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    GestureDetector(
                      onTap: () => {_openFilter()},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 12, 12, 12),
                        child: SvgPicture.asset(
                          'assets/icons/filter_search_gold.svg',
                          colorFilter:
                              ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                        ),
                      ),
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

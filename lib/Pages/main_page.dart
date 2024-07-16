import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Pages/pro_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/pure_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';
import 'package:spoplusplusfy/Pages/social_mode_player_page.dart';

const Color goldColour = Color(0xffFFE8A3);

enum Mode { PureMode, SocialMode, ProMode }

class MainPage extends StatefulWidget {
  final PageController pageController;

  const MainPage({super.key, required this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<MainPage> {
  Mode selectedMode = Mode.PureMode;

  List<Playlist> playlists = [];
  late Future<List<Playlist>> futurePlaylists;

  @override
  void initState() {
    super.initState();
    futurePlaylists = _getPlaylists();
  }

  Future<List<Playlist>> _getPlaylists() async {
    if (playlists.isNotEmpty) return playlists;
    playlists.clear();
    for (int i = 0; i < 10; i++) {
      playlists.add(ArtistWorksManager.getRandomPlaylist());
    }
    return playlists;
  }

  Future<List<Playlist>> _slowUpdatePlaylists() async {
    playlists.clear();
    for (int i = 0; i < 10; i++) {
      playlists.add(ArtistWorksManager.getRandomPlaylist());
    }
    await Future.delayed(const Duration(seconds: 1));
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        backgroundColor: goldColour,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildModeSelector(),
            _buildTitle(),
            FutureBuilder<List<Playlist>>(
              future: futurePlaylists,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Playlists Available'));
                } else {
                  return _buildGridAlbums();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    List<DropdownMenuItem<Mode>> list = [
      const DropdownMenuItem(
        value: Mode.PureMode,
        child: Text('Pure Mode'),
      ),
      const DropdownMenuItem(
        value: Mode.ProMode,
        child: Text('Pro Mode'),
      ),
      const DropdownMenuItem(
        value: Mode.SocialMode,
        child: Text('Social Mode'),
      ),
    ];
    return Container(
      alignment: Alignment.topRight,
      height: 30,
      width: 100,
      child: DropdownButton<Mode>(
        value: selectedMode, // Use selectedMode
        items: list,
        onChanged: (Mode? newValue) {
          setState(() {
            selectedMode = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.02),
      child: const Row(
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Welcome,\nHere Are The Music For You',
                style: TextStyle(
                  fontSize: 30,
                  color: goldColour,
                  fontFamily: 'Noto-Sans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    var newPlaylists = await _slowUpdatePlaylists();
    setState(() {
      playlists = newPlaylists;
    });
  }


  Padding _buildGridAlbums() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  switch (selectedMode) {
                    case Mode.PureMode:
                      return PureModePlayerPage(playlist: playlists[index]);
                    case Mode.ProMode:
                      return ProModePlayerPage(playlist: playlists[index]);
                    case Mode.SocialMode:
                      return SocialModePlayerPage();
                  }
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 3 / 8,
                    height: MediaQuery.of(context).size.width * 3 / 8,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: goldColour,
                        width: 3,
                      ),
                      color: goldColour,
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(playlists[index].getCoverPath(),
                            ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  playlists[index].getName(),
                  style: const TextStyle(
                    color: goldColour,
                    fontFamily: 'Noto-Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        itemCount: playlists.length,
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}

class IntegratedMainPage extends StatefulWidget {
  const IntegratedMainPage({super.key});

  @override
  State<StatefulWidget> createState() => IntegratedMainPageState();
}

class IntegratedMainPageState extends State<IntegratedMainPage> {
  final PageController pageController = PageController();
  static dynamic pageValue = 0.0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        pageValue = pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = [
      MainPage(pageController: pageController),
      SearchPage(pageController: pageController),
    ];
    return PageView.builder(
      controller: pageController,
      itemCount: 2,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Transform(
          transform: Matrix4.identity()..rotateX(pageValue - index),
          child: list[index],
        );
      },
    );
  }
}

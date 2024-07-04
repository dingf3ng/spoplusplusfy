import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Pages/pro_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/pure_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';
import 'package:spoplusplusfy/Pages/social_mode_player_page.dart';

const Color goldColour = Color(0xffFFE8A3);

enum Mode {PureMode, SocialMode, ProMode}

class MainPage extends StatefulWidget {
  final PageController pageController;
  const MainPage({super.key, required this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  Mode selectedMode = Mode.PureMode;
  List<Playlist> playlists = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Playlist>> _getPlaylists() async {
    if (playlists.isNotEmpty) return playlists;

    for (int i = 0; i < 10; i++) {
      playlists.add(await ArtistWorksManager.getRandomPlaylist());
    }
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Playlist>>(
        future: _getPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Playlists Available'));
          } else {
            List<Playlist> playlists = snapshot.data!;
            return _buildMainBody(context, playlists);
          }
        },
      ),
    );
  }

  ListView _buildMainBody(BuildContext context, List<Playlist> playlists) {
    List<DropdownMenuItem<Mode>> list = [
      DropdownMenuItem(
        value: Mode.PureMode,
        child: Text('Pure Mode'),
      ),
      DropdownMenuItem(
        value: Mode.ProMode,
        child: Text('Pro Mode'),
      ),
      DropdownMenuItem(
        value: Mode.SocialMode,
        child: Text('Social Mode'),
      ),
    ];

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
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
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.02),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03)),
              Text(
                'Welcome,\nHere Are The Music For\nYou',
                style: TextStyle(
                  fontSize: 30,
                  color: goldColour,
                  fontFamily: 'Noto-Sans',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: _buildGridAlbums(playlists),
        ),
      ],
    );
  }

  GridView _buildGridAlbums(List<Playlist> playlists) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 0.70,
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
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: goldColour,
                      width: 3,
                    ),
                    color: goldColour,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: SizedBox(
                              width: 50.0,  // Set the width of the loading sign
                              height: 50.0, // Set the height of the loading sign
                              child: Image.asset('assets/images/loading_sign.gif'),
                            ),
                          ),
                        ), Image(
                          image: NetworkImage(playlists[index].getCoverPath(), scale: 0.1),
                          errorBuilder: (context, obj, st) {
                            return Image.asset('assets/images/playlist_cover.jpg');
                          },
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5),
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
    );
  }
}

class IntegratedMainPage extends StatelessWidget {
  const IntegratedMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return PageView(
      controller: pageController,
      scrollDirection: Axis.horizontal,
      children: [
        MainPage(pageController: pageController),
        SearchPage(pageController: pageController),
      ],
    );
  }
}

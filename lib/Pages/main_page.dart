import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Pages/pro_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';

const Color goldColour = Color(0xffFFE8A3);

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
  final HashMap<int, bool> _failed = HashMap();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Playlist>> _getPlaylists() async {
    List<Playlist> playlists = [];
    for (int i = 0; i < 10; i++) {
      playlists.add(await DatabaseHelper().getRandomPlaylist());
      _failed[i] = false;
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
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            '    Welcome,\n    Here Are The Music For\n    You',
            style: TextStyle(
              fontSize: 30,
              color: goldColour,
              fontFamily: 'Noto-Sans',
            ),
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
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, index) {
        try {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProModePlayerPage(playlist: playlists[index]),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.5,
                      height: MediaQuery
                          .of(context)
                          .size
                          .width / 2.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: goldColour,
                          width: 3,
                        ),
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            playlists[index].getCoverPath(),
                          ),
                        ),
                      ),
                      child: Visibility(
                        visible: _failed[index]!,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset('assets/icons/album_gold.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
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
          );
        } catch (e) {
          print('rorororrrr');
          setState(() {
            _failed[index] = true;
          });
        }
      },
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
          MainPage(
            pageController: pageController,
          ),
          SearchPage(
            pageController: pageController,
          ),
        ]);
  }
}

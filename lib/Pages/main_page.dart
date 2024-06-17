import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Pages/pro_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';
import 'package:spoplusplusfy/Pages/pure_mode_player_page.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

const Color goldColour = Color(0xffFFE8A3);

class MainPage extends StatefulWidget {
  final PageController pageController;
  MainPage({super.key, required this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() async {
    ScrollPosition position = _controller.position;
    if (_controller.offset == position.maxScrollExtent) {
      widget.pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.linear);
    } else if (_controller.offset == position.minScrollExtent) {
      widget.pageController.previousPage(duration: Duration(milliseconds: 100), curve: Curves.linear);
    }
  }
  Future<List<Playlist>> _getPlaylists() async {
    List<Playlist> playlists = [];
    for (int i = 0; i < 10; i++) {
      playlists.add(await DatabaseHelper().getRandomPlaylist());
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
      controller: _controller,
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
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProModePlayerPage(playlist: playlists[index]),
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
                    image: DecorationImage(
                      image: NetworkImage(playlists[index].getCoverPath(),
                          scale: 0.1),
                      fit: BoxFit.cover,
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
      ),
      itemCount: playlists.length,
    );
  }
}

class IntegratedMainPage extends StatelessWidget {
  const IntegratedMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    return PageView(controller: _pageController, scrollDirection: Axis.horizontal, children: [
      MainPage(pageController: _pageController,),
      SearchPage(pageController: _pageController,),
    ]);
  }

}
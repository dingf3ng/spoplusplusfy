import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';
import 'package:spoplusplusfy/Pages/player_page.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

const Color goldColour = Color(0xffFFE8A3);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
      {int? currentIndex}) {
    print(
        "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
  }

  Future<List<Playlist>> _getPlaylists() async {
    List<Playlist> playlists = [];
    for (int i = 0; i < 10; i++) {
      playlists.add(await DatabaseHelper().getRandomPlaylist());
    }
    return playlists;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  NotificationListener _navigator(Widget child, Widget to) => NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final ScrollMetrics metrics = notification.metrics;
          // Check if we're at the top of the list and the user is trying to scroll down
          if (metrics.pixels == metrics.minScrollExtent &&
              metrics.axisDirection == AxisDirection.down) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => to),
            );
          }
          return true;
        }
        return false;
      },
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

      ),
      body: _navigator(
        FutureBuilder<List<Playlist>>(
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
        ), const SearchPage()
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
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerPage(playlist: playlists[index]),
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

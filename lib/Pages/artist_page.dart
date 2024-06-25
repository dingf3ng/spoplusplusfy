import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Pages/playlist_page.dart';
import 'package:spoplusplusfy/Pages/pro_mode_player_page.dart';

import '../Classes/album.dart';
import '../Classes/playlist.dart';
import '../Classes/playlist_song_manager.dart';

class ArtistPage extends StatefulWidget {
  final Artist artist;

  const ArtistPage({super.key, required this.artist});

  @override
  State<StatefulWidget> createState() => ArtistPageState();
}

class ArtistPageState extends State<ArtistPage> {
  int _selectedIdx = 0;
  final PageController _controller = PageController();
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _infoBar(),
      body: Column(
        children: [
          _buildNavigationBar(),
          const SizedBox(
            height: 25,
          ),
          _pageView(),
        ],
      ),
    );
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
      height: 20,
      selectedIndex: _selectedIdx,
      destinations: [
        NavigationDestination(
            selectedIcon: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () {
                _selectedIdx = 0;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Works',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2.0, color: secondaryColor),
              ),
              onPressed: () {
                _selectedIdx = 0;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Works',
                style: TextStyle(
                    color: secondaryColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600),
              ),
            ),
            label: ''),
        NavigationDestination(
            selectedIcon: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () {
                _selectedIdx = 1;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Posts',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2.0, color: secondaryColor),
              ),
              onPressed: () {
                _selectedIdx = 1;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text('Works',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  )),
            ),
            label: '')
      ],
    );
  }

  SizedBox _pageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 320,
      child: PageView(
        controller: _controller,
        onPageChanged: (index) => {
          _selectedIdx = index,
          setState(() {}),
        },
        children: [_workPage(), _postPage()],
      ),
    );
  }

  ListView _workPage() {
    return ListView(
      children: [
        _recomend_showcase(),
        _buildGridAlbums(ArtistWorksManager.getAlbumsOfArtist(widget.artist)),
      ],
    );
  }

  ListView _postPage() {
    return ListView(
      children: [
        Container(
          color: Colors.blue,
          height: 500,
        ),
        Container(
          color: Colors.green,
          height: 250,
        ),
      ],
    );
  }

  AppBar _infoBar() {
    return AppBar(
      toolbarHeight: 250,
      backgroundColor: primaryColor,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(25, 60, 0, 40),
        child: Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            color: secondaryColor,
            border: Border.all(color: secondaryColor, width: 3),
            borderRadius: BorderRadius.circular(150),
          ),
          child: ClipOval(
            child: widget.artist.getPortrait(),
          ),
        ),
      ),
      leadingWidth: 170,
      actions: [
        SizedBox(
          width: 230,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.artist.getName(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(secondaryColor),
                      ),
                      onPressed: () => {},
                      child: const Text('Follow')),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Flexible(
                child: Text(
                  'Some random introduction to the singer/band',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 25,
        ),
      ],
    );
  }

  Visibility _recomend_showcase() {
    List<Album> albums = ArtistWorksManager.getAlbumsOfArtist(widget.artist);
    return Visibility(
      visible: albums.isNotEmpty,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Recommended to you',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
              itemCount: albums.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaylistPage(
                                playlist: albums[index],
                                songs: PlaylistSongManager.getSongsForPlaylist(
                                    albums[index]))))
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
                              image: NetworkImage(albums[index].getCoverPath()),
                              fit: BoxFit.cover,
                            )),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 140,
                        child: Text(
                          albums[index].getName(),
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

  Column _buildGridAlbums(List<Playlist> playlists) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                'Albums',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (context, index) => GestureDetector(
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
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                          width: 3,
                        ),
                        color: secondaryColor,
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: Text(
                    playlists[index].getName(),
                    style: const TextStyle(
                      color: secondaryColor,
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
      ],
    );
  }
}

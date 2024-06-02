import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_iterator.dart';

class PlayerPage extends StatefulWidget {
  final Playlist playlist;
  PlayerPage({required this.playlist});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool isPlaying = true;
  String songTitle = '';
  String songArtist = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await PlaylistIterator.setPlaylist(widget.playlist);
    PlaylistIterator.play();
    setState(() {
      isPlaying = PlaylistIterator.isPlaying();
      songTitle = PlaylistIterator.getCurrentSong().getName();
      songArtist = PlaylistIterator.getCurrentSong().getArtist().getName();
    });
  }

  void _pauseOrPlay() {
    setState(() {
      if (isPlaying) {
        PlaylistIterator.pause();
      } else {
        PlaylistIterator.play();
      }
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color goldColour = Color.fromRGBO(255, 232, 163, 1.0);
    const songTitleStyle = TextStyle(
      fontSize: 35,
      color: goldColour,
      fontFamily: 'Poppins',
    );
    const songArtistStyle = TextStyle(
      fontSize: 30,
      color: goldColour,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              songTitle,
              style: songTitleStyle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              songArtist,
              style: songArtistStyle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/playlist_cover.jpg'),
                  ),
                  border: Border.all(
                    color: goldColour,
                    width: 3,
                  ),
                ),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      if (details.delta.dx > 8) {
                        PlaylistIterator.playPreviousSong();
                      } else if (details.delta.dx < -8) {
                        PlaylistIterator.playNextSong();
                      }
                      songTitle = PlaylistIterator.getCurrentSong().getName();
                      songArtist = PlaylistIterator.getCurrentSong().getArtist().getName();
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'lyrics',
                style: TextStyle(
                  color: goldColour,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: isPlaying
                      ? SvgPicture.asset(
                    'assets/icons/play_pause_gold.svg',
                    width: 100,
                    height: 100,
                  )
                      : SvgPicture.asset(
                    'assets/icons/music_play_gold.svg',
                    width: 100,
                    height: 100,
                  ),
                  onPressed: _pauseOrPlay,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

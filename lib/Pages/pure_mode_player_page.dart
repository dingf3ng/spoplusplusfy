import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Classes/artist.dart';
import '../Classes/artist_works_manager.dart';
import '../Classes/playlist.dart';
import '../Classes/playlist_iterator.dart';

class PureModePlayerPage extends StatefulWidget {
  final Playlist playlist;

  const PureModePlayerPage({super.key, required this.playlist});

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PureModePlayerPage> {
  bool isPlaying = true;
  String songTitle = '';
  List<Artist> songArtists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final stopwatch = Stopwatch()..start();
    await PlaylistIterator.setPlaylist(widget.playlist);
    PlaylistIterator.play();
    setState(() {
      isPlaying = PlaylistIterator.isPlaying();
      songTitle = PlaylistIterator.getCurrentSong().getName();
      songArtists = ArtistWorksManager.getArtistsOfSong(
          PlaylistIterator.getCurrentSong());
      isLoading = false;
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
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    var songTitleStyle = TextStyle(
      fontSize: 35,
      color: secondaryColor,
      fontFamily: 'NotoSans',
    );
    var songArtistStyle = TextStyle(
      fontSize: 30,
      color: secondaryColor,
      fontFamily: 'NotoSans',
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(color: secondaryColor,)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    songTitle,
                    style: songTitleStyle,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    ArtistWorksManager.getArtistsOfSongAsString(
                        PlaylistIterator.getCurrentSong()),
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
                        image: DecorationImage(
                          image: Image.network(widget.playlist.getCoverPath(),).image,
                        ),
                        border: Border.all(
                          color: secondaryColor,
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
                            songTitle =
                                PlaylistIterator.getCurrentSong().getName();
                            songArtists = ArtistWorksManager.getArtistsOfSong(
                                PlaylistIterator.getCurrentSong());
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      'lyrics',
                      style: TextStyle(
                        color: secondaryColor,
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

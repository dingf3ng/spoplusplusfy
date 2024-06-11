import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_iterator.dart';

import '../Classes/artist.dart';

/// A stateful widget representing the player page.
class PlayerPage extends StatefulWidget {
  /// The playlist to be played.
  final Playlist playlist;

  /// Constructs a [PlayerPage] instance.
  ///
  /// [playlist]: The playlist to be played.
  const PlayerPage({super.key, required this.playlist});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

/// The state for the [PlayerPage] widget.
class _PlayerPageState extends State<PlayerPage> {
  /// Indicates whether the player is currently playing.
  bool isPlaying = true;

  /// The title of the current song.
  String songTitle = '';

  /// The artist of the current song.
  List<Artist> songArtists = [];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  /// Initializes the player by setting the playlist and starting playback.
  Future<void> _initializePlayer() async {
    await PlaylistIterator.setPlaylist(widget.playlist);
    PlaylistIterator.play();
    setState(() {
      isPlaying = PlaylistIterator.isPlaying();
      songTitle = PlaylistIterator.getCurrentSong().getName();
      songArtists = ArtistWorksManager.getArtistsOfSong(PlaylistIterator.getCurrentSong());
    });
  }

  /// Pauses or resumes playback based on the current state.
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
      fontFamily: 'NotoSans',
    );
    const songArtistStyle = TextStyle(
      fontSize: 30,
      color: goldColour,
      fontFamily: 'NotoSans',
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
              ArtistWorksManager.getArtistsOfSongAsString(
                PlaylistIterator.getCurrentSong()
              ),
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
                        songArtists = ArtistWorksManager.getArtistsOfSong(
                            PlaylistIterator.getCurrentSong()
                        );
                      });
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(40.0),
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

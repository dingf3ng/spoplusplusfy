import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_iterator.dart';
import '../Classes/artist.dart';

// TODO: resolve the issue of red screen with similar method as pure mode page

class ProModePlayerPage extends StatefulWidget {
  final Playlist playlist;

  const ProModePlayerPage({super.key, required this.playlist});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<ProModePlayerPage> {
  bool _isPlaying = true;
  String _songTitle = '';
  List<Artist> _songArtists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await PlaylistIterator.setPlaylist(widget.playlist);
    PlaylistIterator.play();
    setState(() {
      _isPlaying = PlaylistIterator.isPlaying();
      _songTitle = PlaylistIterator.getCurrentSong().getName();
      _songArtists = ArtistWorksManager.getArtistsOfSong(PlaylistIterator.getCurrentSong());
      _isLoading = false;
    });
  }

  void _pauseOrPlay() {
    setState(() {
      if (_isPlaying) {
        PlaylistIterator.pause();
      } else {
        PlaylistIterator.play();
      }
      _isPlaying = !_isPlaying;
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
        child: _isLoading ?
                CircularProgressIndicator()
            :Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _songTitleName(songTitleStyle),
            _songArtistName(songArtistStyle),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: _albumCoverWithSwipeDetection(goldColour),
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
            _musicDecomposeButtons(goldColour),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playPauseButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _musicDecomposeButtons(Color goldColour) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder:
                      (context)  => CircularProgressIndicator()
                  );
                  setState(() {
                    _isPlaying = false;
                  });
                  await PlaylistIterator.separateCurrSongBass();
                  Navigator.of(context).pop();
                  await PlaylistIterator.switchBetweenBassTrackAndSong();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: goldColour,
                  child: SvgPicture.asset('assets/icons/bass_guitar_black.svg', width: 30, height: 30,),
                ),
              ),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = false;
                  });
                  PlaylistIterator.separateCurrSongDrums();
                  PlaylistIterator.switchBetweenDrumTrackAndSong();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: goldColour,
                  child: SvgPicture.asset('assets/icons/drum_black.svg', width: 30, height: 30,),
                ),
              ),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = false;
                  });
                  PlaylistIterator.separateCurrSongVocals();
                  PlaylistIterator.switchBetweenVocalTrackAndSong();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: goldColour,
                  child: SvgPicture.asset('assets/icons/microphone_black.svg', width: 30, height: 30,),
                ),
              ),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = false;
                  });
                  PlaylistIterator.separateCurrSongOthers();
                  PlaylistIterator.switchBetweenOtherTrackAndSong();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: goldColour,
                  child: SvgPicture.asset('assets/icons/more_category_black.svg', width: 30, height: 30,),
                ),
              ),
            ],
          );
  }

  Text _songTitleName(TextStyle songTitleStyle) {
    return Text(
      _songTitle,
      style: songTitleStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Text _songArtistName(TextStyle songArtistStyle) {
    return Text(
      ArtistWorksManager.getArtistsOfSongAsString(
          PlaylistIterator.getCurrentSong()
      ),
      style: songArtistStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  IconButton _playPauseButton() {
    return IconButton(
      icon: _isPlaying
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
    );
  }

  Container _albumCoverWithSwipeDetection(Color goldColour) {
    return Container(
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
            _songTitle = PlaylistIterator.getCurrentSong().getName();
            _songArtists = ArtistWorksManager.getArtistsOfSong(
                PlaylistIterator.getCurrentSong()
            );
          });
        },
      ),
    );
  }
}

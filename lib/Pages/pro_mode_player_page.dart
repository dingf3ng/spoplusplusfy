import 'dart:core';

import 'package:async_button_builder/async_button_builder.dart';
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
  bool _isDecomposing = false;


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
      if (!_isDecomposing) {
        if (_isPlaying) {
          PlaylistIterator.pause();
        } else {
          PlaylistIterator.play();
        }
        _isPlaying = !_isPlaying;
      }
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

    return NotificationListener<AsyncButtonNotification>(
      onNotification: (notification) {
        return notification.buttonState.when(idle: () => true, loading: () => true, success: () {
          setState(() {
            _isDecomposing = false;
          });
          return true;
        }, error: (_, __) {
          _isDecomposing = false;
          return true;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading ? Center(child: CircularProgressIndicator(color: goldColour,))
          : Center(
              child: Column(
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
      ),
    );
  }

  Row _musicDecomposeButtons(Color goldColour) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _asyncButtonBuilder(goldColour, 'assets/icons/bass_guitar_black.svg',
            PlaylistIterator.separateCurrSongBass, PlaylistIterator.switchBetweenBassTrackAndSong),
        SizedBox(width: 20,),
        _asyncButtonBuilder(goldColour, 'assets/icons/drum_black.svg',
            PlaylistIterator.separateCurrSongDrums, PlaylistIterator.switchBetweenDrumTrackAndSong),
        SizedBox(width: 20,),
        _asyncButtonBuilder(goldColour, 'assets/icons/microphone_black.svg',
            PlaylistIterator.separateCurrSongVocals, PlaylistIterator.switchBetweenVocalTrackAndSong),
        SizedBox(width: 20,),
        _asyncButtonBuilder(goldColour, 'assets/icons/more_category_black.svg',
            PlaylistIterator.separateCurrSongOthers, PlaylistIterator.switchBetweenOtherTrackAndSong),
      ],
    );
  }

  AsyncButtonBuilder _asyncButtonBuilder(Color goldColour, String buttonImagePath, Function separate, Function switchBetweenSongAndTrack,) {
    return AsyncButtonBuilder(
        child:   CircleAvatar(
          radius: 30,
          backgroundColor: goldColour,
          child: SvgPicture.asset(
            buttonImagePath, width: 30,
            height: 30,),
        ),
        onPressed: () async {
          setState(() {
            _isPlaying = false;
            _isDecomposing = true;
          });
          await separate();
          await switchBetweenSongAndTrack();
        },
        builder: (context, child, callback, buttonState) {
          Widget button = buttonState.when(
              idle: () => TextButton(
                onPressed: () {if (!_isDecomposing) callback!(); },
                child: child,
                style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero)),),
              loading: () => TextButton(
                onPressed: () {
                  setState(() {
                    _isDecomposing = false;
                    switchBetweenSongAndTrack();
                    PlaylistIterator.stopDecomposing();
                  });
                },
                child: SizedBox(height: 40, width: 40, child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: SvgPicture.asset('assets/icons/record_paused_gold.svg', height: 20, width: 20,
                        colorFilter: ColorFilter.mode(goldColour, BlendMode.srcIn),
                      ),
                    ),
                    Center(child: CircularProgressIndicator(color: goldColour,)),
                  ],
                ),),
              ),
              success: () {
                return ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all(CircleBorder()),
                      backgroundColor: WidgetStateProperty.all(Colors.black),
                      foregroundColor: WidgetStateProperty.all(goldColour),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/checkmark_gold.svg', width: 40,
                      height: 40,));
              },
              error: (_, __) {
                return TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.black),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    shape: WidgetStateProperty.all(CircleBorder()),
                    foregroundColor: WidgetStateProperty.all(goldColour),
                    overlayColor: WidgetStateProperty.all(goldColour),
                  ),

                  child: SvgPicture.asset('assets/icons/exclaimation_mark_gold.svg', width: 40, height: 40,
                    colorFilter: ColorFilter.mode(goldColour, BlendMode.srcIn),
                  ));} );
          return button;
        });
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
            if (details.delta.dx > 8 && !_isDecomposing) {
              PlaylistIterator.playPreviousSong();
            } else if (details.delta.dx < -8 && !_isDecomposing) {
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
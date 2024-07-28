import 'dart:core';

import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_iterator.dart';
import '../Classes/artist.dart';

// TODO: Resolve the issue of the red screen with a similar method as the pure mode page.

/// The ProModePlayerPage is a StatefulWidget that provides the user interface
/// for playing a playlist in Pro Mode. This mode allows users to decompose
/// music into different tracks like bass, drums, vocals, and others.
class ProModePlayerPage extends StatefulWidget {
  final Playlist playlist; // The playlist to be played.

  const ProModePlayerPage({super.key, required this.playlist});

  @override
  PlayerPageState createState() => PlayerPageState();
}

/// The state class for ProModePlayerPage, managing its state and UI.
class PlayerPageState extends State<ProModePlayerPage> {
  bool _isPlaying = true; // Indicates whether music is currently playing.
  String _songTitle = ''; // Title of the current song.
  List<Artist> _songArtists = []; // List of artists for the current song.
  bool _isLoading = true; // Indicates whether the player is initializing.
  bool _isDecomposing = false; // Indicates whether a track is being decomposed.

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
      _isPlaying = PlaylistIterator.isPlaying();
      _songTitle = PlaylistIterator.getCurrentSong().getName();
      _songArtists = ArtistWorksManager.getArtistsOfSong(
          PlaylistIterator.getCurrentSong());
      _isLoading = false;
    });
  }

  /// Toggles the play/pause state of the player.
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

    return NotificationListener<AsyncButtonNotification>(
      onNotification: (notification) {
        return notification.buttonState.when(
            idle: () => true,
            loading: () => true,
            success: () {
              setState(() {
                _isDecomposing = false;
              });
              return true;
            },
            error: (_, __) {
              _isDecomposing = false;
              return true;
            });
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: _isLoading
            ? Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ))
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _songTitleName(songTitleStyle),
              _songArtistName(songArtistStyle),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: _albumCoverWithSwipeDetection(secondaryColor),
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
              _musicDecomposeButtons(),
              const SizedBox(
                height: 50,
              ),
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

  /// Builds the row of buttons for decomposing the music into different tracks.
  Row _musicDecomposeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _asyncButtonBuilder(
            'assets/icons/bass_guitar_black.svg',
            PlaylistIterator.separateCurrSongBass,
            PlaylistIterator.switchBetweenBassTrackAndSong),
        const SizedBox(
          width: 20,
        ),
        _asyncButtonBuilder(
            'assets/icons/drum_black.svg',
            PlaylistIterator.separateCurrSongDrums,
            PlaylistIterator.switchBetweenDrumTrackAndSong),
        const SizedBox(
          width: 20,
        ),
        _asyncButtonBuilder(
            'assets/icons/microphone_black.svg',
            PlaylistIterator.separateCurrSongVocals,
            PlaylistIterator.switchBetweenVocalTrackAndSong),
        const SizedBox(
          width: 20,
        ),
        _asyncButtonBuilder(
            'assets/icons/more_category_black.svg',
            PlaylistIterator.separateCurrSongOthers,
            PlaylistIterator.switchBetweenOtherTrackAndSong),
      ],
    );
  }

  /// Builds an AsyncButton for decomposing a track and switching between tracks.
  AsyncButtonBuilder _asyncButtonBuilder(
      String buttonImagePath,
      Function separate,
      Function switchBetweenSongAndTrack,
      ) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return AsyncButtonBuilder(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: secondaryColor,
          child: SvgPicture.asset(
            buttonImagePath,
            width: 30,
            height: 30,
          ),
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
                onPressed: () {
                  if (!_isDecomposing) callback!();
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: child,
              ),
              loading: () => TextButton(
                onPressed: () {
                  setState(() {
                    _isDecomposing = false;
                    switchBetweenSongAndTrack();
                    PlaylistIterator.stopDecomposing();
                  });
                },
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/icons/record_paused_gold.svg',
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              secondaryColor, BlendMode.srcIn),
                        ),
                      ),
                      Center(
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                          )),
                    ],
                  ),
                ),
              ),
              success: () {
                return ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(const CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      foregroundColor: MaterialStateProperty.all(secondaryColor),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/checkmark_gold.svg',
                      width: 40,
                      height: 40,
                    ));
              },
              error: (_, __) {
                return TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(const CircleBorder()),
                      foregroundColor: MaterialStateProperty.all(secondaryColor),
                      overlayColor: MaterialStateProperty.all(secondaryColor),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/exclaimation_mark_gold.svg',
                      width: 40,
                      height: 40,
                      colorFilter:
                      ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                    ));
              });
          return button;
        });
  }

  /// Builds the text widget for displaying the song title.
  Text _songTitleName(TextStyle songTitleStyle) {
    return Text(
      _songTitle,
      style: songTitleStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  /// Builds the text widget for displaying the song artists.
  Text _songArtistName(TextStyle songArtistStyle) {
    return Text(
      ArtistWorksManager.getArtistsOfSongAsString(
          PlaylistIterator.getCurrentSong()),
      style: songArtistStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  /// Builds the play/pause button.
  SizedBox _playPauseButton() {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return SizedBox(
      width: 110,
      height: 110,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: secondaryColor,
        ),
        onPressed: _pauseOrPlay,
        child: _isPlaying
            ? SvgPicture.asset(
          'assets/icons/music_pause_black.svg',
          width: 100,
          height: 100,
        )
            : SvgPicture.asset(
          'assets/icons/music_play_black.svg',
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  /// Builds the album cover widget with swipe detection for changing songs.
  Container _albumCoverWithSwipeDetection(Color goldColour) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(widget.playlist.getCoverPath(), scale: 0.1),
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
                PlaylistIterator.getCurrentSong());
          });
        },
      ),
    );
  }
}

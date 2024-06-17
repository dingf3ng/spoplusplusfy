import 'dart:io';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Classes/track.dart';
import 'package:http/http.dart' as http;

class PlaylistIterator {
  static final AudioPlayer _player = AudioPlayer();
  static final List<Song> _currentList = [];
  static Song? _currentSong;
  static Track? _currentVocalTrack;
  static Track? _currentDrumTrack;
  static Track? _currentBassTrack;
  static Track? _currentOtherTrack;
  static int songIndex = 0;
  static bool _isSeparating = false;

  static void changeProgressTo(Duration progress) {
    _player.seek(progress);
  }

  static bool isSeparating() => _isSeparating;

  static Song getCurrentSong() => _currentSong ?? (throw StateError('No current song'));

  static bool isPlaying() => _player.playing;

  static Future<void> setPlaylist(Playlist playlist) async {
    List<AudioSource> playlistSource = [];
    _currentList.clear(); // Clear the list to avoid duplicates
    _clearTracks();

    for (Song song in await PlaylistSongManager.getSongsForPlaylist(playlist)) {
      playlistSource.add(song.getAudioSource());
      _currentList.add(song);
    }

    ConcatenatingAudioSource sourceForPlayer = ConcatenatingAudioSource(children: playlistSource);

    await _player.setAudioSource(sourceForPlayer);


    _currentSong = _currentList[0];
  }

  static void _clearTracks() {
    _currentVocalTrack = null;
    _currentBassTrack = null;
    _currentDrumTrack = null;
    _currentOtherTrack = null;
  }

  static void play() {
    _player.play();
  }

  static void pause() {
    _player.pause();
  }

  static void fastForward(Duration time) {
    Duration songTotalLength = _player.duration ?? Duration.zero;

    if (_player.position + time < songTotalLength) {
      _player.seek(_player.position + time);
    } else {
      _player.seek(_player.duration);
    }
  }

  static void fastRewind(Duration time) {
    if (_player.position - time > Duration.zero) {
      _player.seek(_player.position - time);
    } else {
      _player.seek(Duration.zero);
    }
  }

  static void playNextSong() {
    _player.seekToNext();
    _currentSong = _currentList[_player.currentIndex ?? 0];
  }

  static void playPreviousSong() {
    _player.seekToPrevious();
    _currentSong = _currentList[_player.currentIndex ?? 0];
  }

  static Future<void> separateCurrSongVocals() async {
    _separateCurrSong('vocals');
  }

  static Future<void> separateCurrSongDrums() async {
    _separateCurrSong('drums');
  }

  static Future<void> separateCurrSongBass() async {
    _separateCurrSong('bass');
  }

  static Future<void> separateCurrSongOthers() async {
    _separateCurrSong('others');
  }

  static Future<void> _separateCurrSong(String trackType) async {
    _isSeparating = true;
    _player.pause();
    if (_currentSong == null) {
      throw StateError('No current song');
    }

    if (_currentVocalTrack != null && trackType == 'vocals') {
      return;
    }

    if (_currentDrumTrack != null && trackType == 'drums') {
      return;
    }

    if (_currentBassTrack != null && trackType == 'bass') {
      return;
    }

    if (_currentOtherTrack != null && trackType == 'others') {
      return;
    }

    var songFileBytes = (await rootBundle.load('assets/songs/${_currentSong!.getId().toString().padLeft(6, '0').substring(0, 3)}/${_currentSong!.getId().toString().padLeft(6, '0')}.mp3'))
                      .buffer.asUint8List();

    var request = http.MultipartRequest('POST', Uri.parse('http://10.211.55.5:8000/api/decompose/to_$trackType'));
    request.files.add(http.MultipartFile.fromBytes('file', songFileBytes, filename: 'current_song.mp3'));

    var response = await request.send();

    if (response.statusCode == 200) {
      var dir = await getTemporaryDirectory();
      File trackFile = File('${dir.path}/$trackType.mp3');
      await trackFile.writeAsBytes(await response.stream.toBytes());

      Track track = Track(
        audio: AudioSource.uri(Uri.file(trackFile.path)),
        id: _currentSong!.getId(),
        duration: _currentSong!.getDuration(),
        volume: _currentSong!.getVolume(),
      );

      if (trackType == 'vocals') {
        _currentVocalTrack = track;
      } else if (trackType == 'drums') {
        _currentDrumTrack = track;
      } else if (trackType == 'bass') {
        _currentBassTrack = track;
      } else if (trackType == 'others') {
        _currentOtherTrack = track;
      }
      _isSeparating = false;
      print('track saved at: ${trackFile.path}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  static Future<void> switchBetweenVocalTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentVocalTrack!);
  }

  static Future<void> switchBetweenDrumTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentDrumTrack!);
  }

  static Future<void> switchBetweenBassTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentBassTrack!);
  }

  static Future<void> switchBetweenOtherTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentOtherTrack!);
  }

  static Future<void> _switchBetweenTrackAndSong(Track track) async {
    // Save the current position
    Duration currentPosition = _player.position;

    // Load and play the vocal track from the same position
    await _player.setAudioSource(track.getAudioSource());
    await _player.seek(currentPosition);
  }
}
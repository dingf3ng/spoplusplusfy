import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Classes/track.dart';
import 'package:http/http.dart' as http;

import '../Utilities/api_service.dart';

const dfIP = '192.168.2.169:8000';

/// A static class for managing playlist iteration and audio playback.
///
/// This class provides functionality for playing, pausing, and navigating through
/// songs in a playlist, as well as separating and playing individual tracks.
class PlaylistIterator {
  /// The audio player used for playback.
  static final AudioPlayer _player = AudioPlayer();

  /// The current list of songs in the playlist.
  static final List<Song> _currentList = [];

  /// The currently playing song.
  static Song? _currentSong;

  /// The separated vocal track of the current song.
  static Track? _currentVocalTrack;

  /// The separated drum track of the current song.
  static Track? _currentDrumTrack;

  /// The separated bass track of the current song.
  static Track? _currentBassTrack;

  /// The separated 'other' track of the current song.
  static Track? _currentOtherTrack;

  /// The index of the current song in the playlist.
  static int songIndex = 0;

  /// The HTTP client used for making API requests.
  static http.Client? _client;

  /// Flag indicating whether a separated track is currently playing.
  static bool _isPlayingTrack = false;

  /// Changes the playback progress to the specified duration.
  ///
  /// Parameters:
  /// - [progress]: The new playback position.
  static void changeProgressTo(Duration progress) {
    _player.seek(progress);
  }

  /// Gets the currently playing song.
  ///
  /// Returns the current [Song], or throws a [StateError] if no song is playing.
  static Song getCurrentSong() =>
      _currentSong ?? (throw StateError('No current song'));

  /// Checks if audio is currently playing.
  ///
  /// Returns [true] if audio is playing, [false] otherwise.
  static bool isPlaying() => _player.playing;

  /// Sets the current playlist and prepares it for playback.
  ///
  /// Parameters:
  /// - [playlist]: The [Playlist] to set as current.
  static Future<void> setPlaylist(Playlist playlist) async {
    List<AudioSource> playlistSource = [];
    _currentList.clear(); // Clear the list to avoid duplicates
    _clearTracks();
    for (Song song in PlaylistSongManager.getSongsForPlaylist(playlist)) {
      playlistSource.add(await song.getAudioSource());
      _currentList.add(song);
    }
    print(playlistSource.length);
    ConcatenatingAudioSource sourceForPlayer =
    ConcatenatingAudioSource(children: playlistSource);
    await _player.setAudioSource(sourceForPlayer);
    _currentSong = _currentList[0];
  }

  /// Clears all separated tracks.
  static void _clearTracks() {
    _currentVocalTrack = null;
    _currentBassTrack = null;
    _currentDrumTrack = null;
    _currentOtherTrack = null;
  }

  /// Starts or resumes playback.
  static void play() {
    _player.play();
  }

  /// Pauses playback.
  static void pause() {
    _player.pause();
  }

  /// Fast forwards the current song by the specified duration.
  ///
  /// Parameters:
  /// - [time]: The duration to fast forward.
  static void fastForward(Duration time) {
    Duration songTotalLength = _player.duration ?? Duration.zero;

    if (_player.position + time < songTotalLength) {
      _player.seek(_player.position + time);
    } else {
      _player.seek(_player.duration);
    }
  }

  /// Rewinds the current song by the specified duration.
  ///
  /// Parameters:
  /// - [time]: The duration to rewind.
  static void fastRewind(Duration time) {
    if (_player.position - time > Duration.zero) {
      _player.seek(_player.position - time);
    } else {
      _player.seek(Duration.zero);
    }
  }

  /// Plays the next song in the playlist.
  static void playNextSong() {
    _player.seekToNext();
    _currentSong = _currentList[_player.currentIndex ?? 0];
  }

  /// Plays the previous song in the playlist.
  static void playPreviousSong() {
    _player.seekToPrevious();
    _currentSong = _currentList[_player.currentIndex ?? 0];
  }

  /// Separates the vocals from the current song.
  static Future<void> separateCurrSongVocals() async {
    await _separateCurrSong('vocals');
  }

  /// Separates the drums from the current song.
  static Future<void> separateCurrSongDrums() async {
    await _separateCurrSong('drums');
  }

  /// Separates the bass from the current song.
  static Future<void> separateCurrSongBass() async {
    await _separateCurrSong('bass');
  }

  /// Separates other instruments from the current song.
  static Future<void> separateCurrSongOthers() async {
    await _separateCurrSong('others');
  }

  /// Separates a specific track type from the current song.
  ///
  /// Parameters:
  /// - [trackType]: The type of track to separate ('vocals', 'drums', 'bass', or 'others').
  static Future<void> _separateCurrSong(String trackType) async {
    _client = http.Client();
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

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://$fhlIP/api/decompose/to_$trackType/${_currentSong!.getId().toString().padLeft(6, '0')}'));

    var response = await _client!.send(request);

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
      print('track saved at: ${trackFile.path}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  /// Stops the ongoing track separation process.
  static Future<void> stopDecomposing() async {
    if (_client != null) {
      _client!.close();
      print('Decomposing stopped');
    }
  }

  /// Switches between playing the vocal track and the full song.
  static Future<void> switchBetweenVocalTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentVocalTrack!);
  }

  /// Switches between playing the drum track and the full song.
  static Future<void> switchBetweenDrumTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentDrumTrack!);
  }

  /// Switches between playing the bass track and the full song.
  static Future<void> switchBetweenBassTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentBassTrack!);
  }

  /// Switches between playing the 'other' track and the full song.
  static Future<void> switchBetweenOtherTrackAndSong() async {
    _switchBetweenTrackAndSong(_currentOtherTrack!);
  }

  /// Switches between playing a specific track and the full song.
  ///
  /// Parameters:
  /// - [track]: The [Track] to switch to/from.
  static Future<void> _switchBetweenTrackAndSong(Track track) async {
    // Save the current position
    Duration currentPosition = _player.position;

    // Load and play the vocal track from the same position
    if (_isPlayingTrack) {
      _isPlayingTrack = false;
      await _player.setAudioSource(await _currentSong!.getAudioSource());
      await _player.seek(currentPosition);
      return;
    }
    _isPlayingTrack = true;
    await _player.setAudioSource(await track.getAudioSource());
    await _player.seek(currentPosition);
  }
}

import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class PlaylistIterator {
  static final AudioPlayer _player = AudioPlayer();
  static List<Song> _currentList = [];
  static Song? _currentSong;
  static int songIndex = 0;

  static void changeProgressTo(Duration progress) {
    _player.seek(progress);
  }

  static Song getCurrentSong() => _currentSong ?? (throw StateError('No current song'));

  static bool isPlaying() => _player.playing;

  static Future<void> setPlaylist(Playlist playlist) async {
    List<AudioSource> playlistSource = [];
    _currentList.clear(); // Clear the list to avoid duplicates

    for (Song song in await PlaylistSongManager.getSongsForPlaylist(playlist)) {
      playlistSource.add(song.getAudioSource());
      _currentList.add(song);
    }

    ConcatenatingAudioSource sourceForPlayer = ConcatenatingAudioSource(children: playlistSource);

    await _player.setAudioSource(sourceForPlayer);

    _player.currentIndexStream.listen((index) {
      if (index != null && index < _currentList.length) {
        _currentSong = _currentList[index];
      }
    });

    if (_currentList.isNotEmpty) {
      _currentSong = _currentList[0];
    }
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
}

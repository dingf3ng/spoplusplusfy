import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class PlaylistIterator {
  static final AudioPlayer _player = AudioPlayer();
  static late List<Song> _currentList;
  static late Song _currentSong;

  static void changeProgressTo(Duration progress) {
    _player.seek(progress);
  }

  static void setPlaylist(Playlist playlist) {
    List<AudioSource> playlistSource = [];
    List<Song> recordOfSongs = [];

    for (Song song in PlaylistSongManager.getSongsForPlaylist(playlist)) {
      playlistSource.add(song.getAudioSource());
      recordOfSongs.add(song);
    }

    _currentList = recordOfSongs;
    ConcatenatingAudioSource sourceForPlayer =
        ConcatenatingAudioSource(children: playlistSource);

    _player.setAudioSource(sourceForPlayer);
  }

  static void play() {
    _player.play();
  }

  static void pause() {
    _player.pause();
  }

  static void fastForward(Duration time) {
    Duration songTotalLength;

    // Check to ensure that songTotalLength is never null
    if (_player.duration == null) {
      songTotalLength = Duration.zero;
    } else {
      songTotalLength = _player.duration!;
    }

    // fast forward by time specified, if not beyond length of song
    if (_player.position + time < songTotalLength) {
      _player.seek(_player.position + time);
    } else {
      _player.seek(_player.duration);
    }
  }

  static void fastRewind(Duration time) {
    // fast rewind by time specified, if destination progress is not below 0
    if (_player.position - time > Duration.zero) {
      _player.seek(_player.position - time);
    } else {
      _player.seek(Duration.zero);
    }
  }

  static void playNextSong() {
    _player.seekToNext();
  }

  static void playPreviousSong() {
    _player.seekToPrevious();
  }
}

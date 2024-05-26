import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class PlaylistIterator {
  static AudioPlayer player = AudioPlayer();
  static late List<Song> currentList;
  static late Song currentSong;

  static void changeProgressTo(Duration progress) {
    player.seek(progress);
  }

  static void setPlaylist(Playlist playlist) {
    List<AudioSource> playlistSource = [];

    for (Song song in playlist.getSongs()) {
      playlistSource.add(song.getAudioSource());
    }

    ConcatenatingAudioSource sourceForPlayer =
        ConcatenatingAudioSource(children: playlistSource);

    player.setAudioSource(sourceForPlayer);
  }
  static void play() {
    player.play();
  }
  static void pause() {
    player.pause();
  }
  static void fastForward(Duration time) {
    Duration songTotalLength;

    // Check to ensure that songTotalLength is never null
    if (player.duration == null) {
      songTotalLength = Duration.zero;
    } else {
      songTotalLength = player.duration!;
    }

    // fast forward by time specified, if not beyond length of song
    if (player.position + time < songTotalLength) {
      player.seek(player.position + time);
    } else {
      player.seek(player.duration);
    }
  }

  static void fastRewind(Duration time) {
    // fast rewind by time specified, if destination progress is not below 0
    if (player.position - time > Duration.zero) {
      player.seek(player.position - time);
    } else {
      player.seek(Duration.zero);
    }

  }
  static void playNextSong() {
    player.seekToNext();
  }
  static void playPreviousSong() {
    player.seekToPrevious();
  }
}
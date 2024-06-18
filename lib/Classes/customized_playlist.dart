
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';


class CustomizedPlaylist extends Playlist {

  CustomizedPlaylist({
    required super.name,
    required super.playlistCoverPath,
    required super.id,
    required super.timeLength,
    super.mutable = true,
  });

  @override
  void updateWith(Song song) {
    super.updateWith(song);
    PlaylistSongManager.addSongToPlayList(song, this);
  }

  @override
  void delete() {
    PlaylistSongManager.deletePlaylist(this);
  }



}
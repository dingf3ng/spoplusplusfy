import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'dart:collection';

class Playlist {
  String name;
  String playlistCoverImagePath;
  int id;
  int timeLength;
  bool mutable;
  
  Playlist({
    required this.name,
    required this.playlistCoverImagePath,
    required this.id,
    required this.mutable,
    required this.timeLength
  });

  int getHashCode() {
    return id.hashCode;
  }

  void delete() {
    PlaylistSongManager.deletePlaylist(this);
  }

  int length() {
    return timeLength;
  }

}
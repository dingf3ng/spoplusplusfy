
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
    return this.id.hashCode;
  }

  List<Song> getSongs() {

  }

}
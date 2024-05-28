import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

import 'album.dart';

class Artist {
  List<Song> _songs = [];
  List<Album> _albums = [];

  // Loads songs and albums from database and put them in fields
  void _loadSongsAndAlbums() {

  }

  List<Song> getSongs() {
    return _songs;
  }
  List<Album> getAlbums() {
    return _albums;
  }
}
import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

import 'album.dart';

class Artist extends Person {
  List<Song> _songs = [];
  List<Album> _albums = [];

  Artist({
    required String name,
    required int id,
    required String gender,
    required Image portrait,
  }) : super(name: name, id: id, gender: gender, portrait: portrait) {
    // Add any additional initialization logic here
  }
  // Loads songs and albums from database and put them in fields
  void _loadSongsAndAlbums() {}

  List<Song> getSongs() {
    return _songs;
  }

  List<Album> getAlbums() {
    return _albums;
  }
}

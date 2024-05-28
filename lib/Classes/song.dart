
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';

import 'Artist.dart';

class Song {
  late String _name;
  late Artist _artist;
  late Playlist belongingPlaylist;
  late int id;
  late bool mutable;

  void addToPlaylist(Playlist playlist) {
    PlaylistSongManager.addSongToPlayList(this, playlist);
    PlaylistSongManager.addPlaylistToSong(this, playlist);
  }

  AudioSource getAudioSource() {

  }

  List<Video> getSocialModeVideos() {}

  Image getImage() {
    return Image.file();
  }
}
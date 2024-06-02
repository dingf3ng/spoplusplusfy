import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/voice.dart';

import 'Artist.dart';

class Song extends Voice {
  late String _name;
  late Artist _artist;
  late Playlist belongingPlaylist;
  late bool mutable;

  Song(int id, int duration, String name, Artist artist, Playlist playlist,
      bool isMutable)
      : super(
            id: id,
            duration: duration,
            audio: AudioSource.uri(Uri.parse(
                'assets/songs/${id.toString().substring(0, 3)}/$id.mp3'))) {
    _name = name;
    _artist = artist;
    belongingPlaylist = playlist;
    mutable = isMutable;
  }

  String getName() {
    return _name;
  }
  getArtist() => _artist;
}

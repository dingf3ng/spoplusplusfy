import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/voice.dart';

import 'Name.dart';
import 'artist.dart';

class Song extends Voice implements Name {
  late String _name;
  late Playlist belongingPlaylist;
  late bool mutable;

  Song({required id, required duration, required name, required artist, required playlist,
      required isMutable, required volume})
      : super(
            volume: volume,
            id: id,
            duration: duration,
            audio: AudioSource.uri(Uri.parse(
                'assets/songs/${id.toString().substring(0, 3)}/$id.mp3'))) {
    _name = name;
    belongingPlaylist = playlist;
    mutable = isMutable;
  }

  @override
  String getName() {
    return _name;
  }

  @override
  void setName(String name) {
    return;
  }
}

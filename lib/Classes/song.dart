import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/voice.dart';

import 'Name.dart';
import 'artist.dart';

class Song extends Voice implements Name {
  late String _name;
  Playlist? belongingPlaylist;
  late bool mutable;

  Song({
    required super.id,
    required super.duration,
    required name,
    required isMutable,
    required super.volume
  }) : super(
            audio: AudioSource.uri(Uri.parse(
                'assets/songs/${id.toString().substring(0, 3)}/$id.mp3'))) {
    _name = name;
    mutable = isMutable;
  }

  factory Song.fromMap(Map<String, Object?> map) {
    return Song(
        id: map['song_id'] as int,
        duration: map['duration'] as int,
        name: map['name'] as String,
        isMutable: false,
        volume:100
    );
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

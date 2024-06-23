import 'dart:convert';

import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/voice.dart';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:http/http.dart' as http;

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
                'assets/songs/${id.toString().padLeft(3, '0')}/${id.toString().padLeft(6, '0')}.mp3'))) {
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

  @override
  Future<AudioSource> getAudioSource() async{
    String idStr = getId().toString().padLeft(6, '0'); // Ensure the ID has 6 digits, padding with leading zeros if necessary
    String firstThreeDigitsStr = idStr.substring(0, 3); // Extract the first three digits
    print('here................');
    final response = await http.get(
        Uri.parse('http://http://192.168.2.169:8000/get_song/$firstThreeDigitsStr/$idStr'));
    print('here................');
    final data = json.decode(response.body);
    final url = data['file_url'];
    return AudioSource.uri(url);
  }
}

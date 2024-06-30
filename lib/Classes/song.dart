import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/voice.dart';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:http/http.dart' as http;

const fhlIP = '10.211.55.5:8000';
const dfIP = '192.168.2.169:8000';
const local = '10.0.2.2:8000';

class Song extends Voice implements Name {
  static http.Client? _client;
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
  Future<AudioSource> getAudioSource() async {
    _client = http.Client();
    String idStr = getId().toString().padLeft(6, '0'); // Ensure the ID has 6 digits, padding with leading zeros if necessary
    String index = idStr.substring(0, 3); // Extract the first three digits
    final response = await http.post(
        Uri.parse('http://$fhlIP/api/get_song/$index/$idStr'));
    print('herer');
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$index$idStr.mp3');
      await file.writeAsBytes(bytes);
      print('now');
      return AudioSource.uri(Uri.file(file.path));
    } else {
      throw Exception('Failed to load song, status code: ${response.statusCode}');
    }
  }
}

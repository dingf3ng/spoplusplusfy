import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/voice.dart';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:http/http.dart' as http;

import '../Utilities/api_service.dart';


/// Represents a song in the music application.
///
/// This class extends [Voice] and implements [Name], providing functionality
/// specific to songs, including audio playback and metadata management.
class Song extends Voice implements Name {
  /// HTTP client for making network requests.
  static http.Client? _client;

  /// The name of the song.
  late String _name;

  /// The playlist this song belongs to, if any.
  Playlist? belongingPlaylist;

  /// Whether the song's metadata can be modified.
  late bool mutable;

  /// Creates a [Song] instance.
  ///
  /// Parameters:
  /// - [id]: The unique identifier for the song.
  /// - [duration]: The duration of the song in seconds.
  /// - [name]: The name of the song.
  /// - [isMutable]: Whether the song's metadata can be modified.
  /// - [volume]: The default volume for the song (0-100).
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

  /// Creates a [Song] instance from a map of key-value pairs.
  ///
  /// Parameters:
  /// - [map]: A map containing the song's data.
  ///
  /// Returns a new [Song] instance.
  factory Song.fromMap(Map<String, Object?> map) {
    return Song(
        id: map['song_id'] as int,
        duration: map['duration'] as int,
        name: map['name'] as String,
        isMutable: false,
        volume: 100
    );
  }

  /// Gets the name of the song.
  ///
  /// Returns the song's name as a [String].
  @override
  String getName() {
    return _name;
  }

  /// Sets the name of the song.
  ///
  /// This method is currently a no-op and does not change the song's name.
  ///
  /// Parameters:
  /// - [name]: The new name for the song.
  @override
  void setName(String name) {
    return;
  }

  /// Gets the audio source for the song.
  ///
  /// This method fetches the song file from the server and saves it locally
  /// before returning an [AudioSource] that can be used for playback.
  ///
  /// Returns a [Future<AudioSource>] that can be used with an audio player.
  /// Throws an exception if the song fails to load.
  @override
  Future<AudioSource> getAudioSource() async {
    _client = http.Client();
    String idStr = getId().toString().padLeft(6, '0'); // Ensure the ID has 6 digits, padding with leading zeros if necessary
    String index = idStr.substring(0, 3); // Extract the first three digits
    final response = await http.post(
        Uri.parse('http://$fhlIP/api/get_song/$index/$idStr'));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$index$idStr.mp3');
      await file.writeAsBytes(bytes);
      return AudioSource.uri(Uri.file(file.path));
    } else {
      throw Exception('Failed to load song, status code: ${response.statusCode}');
    }
  }
}

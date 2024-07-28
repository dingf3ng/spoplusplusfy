import 'package:spoplusplusfy/Classes/voice.dart';

/// Represents a track in the music application.
///
/// This class extends [Voice] and represents a specific track or stem
/// of a song, such as vocals, drums, bass, or other instruments.
class Track extends Voice {
  /// Creates a [Track] instance.
  ///
  /// Parameters:
  /// - [audio]: The [AudioSource] for the track.
  /// - [id]: The unique identifier for the track.
  /// - [duration]: The duration of the track in seconds.
  /// - [volume]: The default volume for the track (0-100).
  Track({
    required super.audio,
    required super.id,
    required super.duration,
    required super.volume
  });
}
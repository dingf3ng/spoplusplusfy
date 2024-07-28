import 'package:just_audio/just_audio.dart';

/// An abstract class representing an audio voice in the application.
///
/// This class serves as a base for other audio-related classes, providing
/// common functionality for managing audio sources, volume, and metadata.
abstract class Voice {
  /// The maximum volume level.
  static const maxVolume = 100;

  /// The minimum volume level.
  static const minVolume = 0;

  /// The audio source for this voice.
  late final AudioSource _audio;

  /// The unique identifier for this voice.
  late final int _id;

  /// The duration of the audio in seconds.
  late final int _duration;

  /// The current volume level of the voice.
  int _volume;

  /// Creates a [Voice] instance.
  ///
  /// Parameters:
  /// - [audio]: The [AudioSource] for this voice.
  /// - [id]: The unique identifier for this voice.
  /// - [duration]: The duration of the audio in seconds.
  /// - [volume]: The initial volume level (0-100).
  Voice({
    required AudioSource audio,
    required int id,
    required int duration,
    required int volume
  })  : _audio = audio,
        _id = id,
        _duration = duration,
        _volume = volume;

  /// Gets the current volume level.
  ///
  /// Returns the current volume as an [int] between 0 and 100.
  int getVolume() {
    return _volume;
  }

  /// Sets the volume level.
  ///
  /// Parameters:
  /// - [toVol]: The new volume level to set (should be between 0 and 100).
  void setVolume(int toVol) {
    _volume = toVol;
  }

  /// Gets the unique identifier of this voice.
  ///
  /// Returns the ID as an [int].
  int getId() {
    return _id;
  }

  /// Gets the duration of the audio.
  ///
  /// Returns the duration in seconds as an [int].
  int getDuration() {
    return _duration;
  }

  /// Gets the audio source for this voice.
  ///
  /// Returns a [Future<AudioSource>] that can be used with an audio player.
  Future<AudioSource> getAudioSource() async {
    return _audio;
  }
}

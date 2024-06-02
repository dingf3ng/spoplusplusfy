import 'package:just_audio/just_audio.dart';

abstract class Voice {
  static const maxVolume = 100;
  static const minVolume = 0;

  late AudioSource _audio;
  late int _id;
  late int _duration;
  int _volume;

  Voice({
    required AudioSource audio,
    required int id,
    required int duration,
    required int volume
  }) :
        _audio = audio,
        _id = id,
        _duration = duration,
        _volume = volume;

  int getVolume() {
    return _volume;
  }

  void setVolume(int toVol) {
    _volume = toVol;
  }

  int getId() {
    return _id;
  }

  int getDuration() {
    return _duration;
  }

  AudioSource getAudioSource() {
    String idStr = _id.toString().padLeft(6, '0'); // Ensure the ID has 6 digits, padding with leading zeros if necessary
    String firstThreeDigitsStr = idStr.substring(0, 3); // Extract the first three digits
    return AudioSource.asset('assets/songs/$firstThreeDigitsStr/$idStr.mp3');
  }
}

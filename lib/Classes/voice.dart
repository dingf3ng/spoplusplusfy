import 'package:just_audio/just_audio.dart';

abstract class Voice {
  static const maxVolume = 100;
  static const minVolume = 0;

  late final AudioSource _audio;
  late final int _id;
  late final int _duration;
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

  Future<AudioSource> getAudioSource() async {
    return _audio;
  }
}

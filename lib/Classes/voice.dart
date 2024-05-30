import 'package:just_audio/just_audio.dart';

class Voice {
  AudioSource audio;
  int id;
  int duration;

  Voice({
    required this.audio,
    required this.id,
    required this.duration,
  });

  int getId() {
    return id;
  }

  AudioSource getAudioSource() {
    return AudioSource.uri(
        Uri.parse('assets/songs/${id.toString().substring(0, 3)}/$id.mp3'));
  }
}

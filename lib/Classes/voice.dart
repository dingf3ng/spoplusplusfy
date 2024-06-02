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
    String idStr = id.toString().padLeft(6, '0'); // Ensure the ID has 6 digits, padding with leading zeros if necessary
    String firstThreeDigitsStr = idStr.substring(0, 3); // Extract the first three digits
    return AudioSource.asset('assets/songs/$firstThreeDigitsStr/$idStr.mp3');
  }
}


import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/voice.dart';

class Song extends Voice{

  late String _name;


  Song({
    required name,
    required artist,
    required super.audio,
    required super.id,
    required super.duration,
    required super.volume}) : _name = name;

  String getName() {
    return _name;
  }



}

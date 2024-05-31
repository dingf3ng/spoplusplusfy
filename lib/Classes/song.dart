
import 'package:spoplusplusfy/Classes/Name.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/voice.dart';

class Song extends Voice implements Name{

  late String _name;

  Song({
    required name,
    required artist,
    required super.audio,
    required super.id,
    required super.duration,
    required super.volume}) : _name = name;

  @override
  String getName() {
    return _name;
  }

  @override
  void setName(String name) {
    return;
  }

}

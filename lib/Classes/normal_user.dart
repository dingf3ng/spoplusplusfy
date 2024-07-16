import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:http/http.dart' as http;
import 'package:spoplusplusfy/Classes/song.dart';

class NormalUser extends Person {
  NormalUser({required super.name,
    required super.id,
    required super.gender,
    required super.portrait,
    required super.age});

  static late NormalUser currentUser;

}
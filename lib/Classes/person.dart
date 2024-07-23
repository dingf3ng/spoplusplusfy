import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:spoplusplusfy/Classes/follower_manager.dart';
import 'package:http/http.dart' as http;
import 'package:spoplusplusfy/Classes/song.dart';

enum Gender { Male, Female, Mysterious }

abstract class Person implements Name {
  String _name;
  late final int _id;
  Gender _gender;
  int? _age;
  Image _portrait;

  Person({
    required String name,
    required int id,
    required Gender gender,
    required Image portrait,
    int? age,
  })  : _name = name,
        _id = id,
        _gender = gender,
        _portrait = portrait,
        _age = age;

  @override
  void setName(String s) {
    _name = s;
  }

  void setGender(Gender g) {
    _gender = g;
  }

  void setAge(int a) {
    _age = a;
  }

  void setPortrait(Image i) {
    _portrait = i;
  }

  @override
  String getName() => _name;

  Gender getGender() {
    return _gender;
  }

  int? getAge() => _age;

  Image getPortrait() => _portrait;

  int getId() => _id;

  void follow(Person p) {
    FollowerManager.addToFollowing(this, p);
  }

  void unfollow(Person p) {
    FollowerManager.removeFromFollowing(this, p);
  }

  void delete() {
    FollowerManager.deletePerson(this);
  }
  
  static Future<bool> deviceIsLoggedIn() async {
    return (SharedPreferences.getInstance()).then((sp) { return sp.getString('token')!.isEmpty;});
  }
  
  static Future<String> getToken() {
    return (SharedPreferences.getInstance()).then((sp) { return sp.getString('token')!;});
  }
}

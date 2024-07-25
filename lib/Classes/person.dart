import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:spoplusplusfy/Classes/follower_manager.dart';
import 'package:http/http.dart' as http;
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Classes/video.dart';

enum Gender { Male, Female, Mysterious }

abstract class Person implements Name {
  String _name;
  late final int _id;
  Gender _gender;
  int? _age;
  Image _portrait;
  String _bio;
  static Future<Person>? _personLoggedIn;

  Person({
    required String name,
    required int id,
    required Gender gender,
    required Image portrait,
    required String bio,
    int? age,
  })  : _name = name,
        _id = id,
        _gender = gender,
        _portrait = portrait,
        _age = age,
        _bio = bio
  ;

  String get bio => _bio;

  factory Person.fromProfileJson(String json) {
    Map jsonMap = jsonDecode(json);
    String name = jsonMap['username'] ?? 'unknown';
    int id = jsonMap['id'] ?? '0';
    Gender gender = Gender.Mysterious;
    Image portrait = jsonMap['portrait']??Image.asset('assets/images/pf.jpg');
    String bio = jsonMap['bio'];
    int age = jsonMap['age'] ?? 0;
    bool isArtist = jsonMap['is_artist'] ?? false;
    if (!isArtist) {
      return NormalUser(name: name,
          id: id,
          gender: gender,
          portrait: portrait,
          age: age,
          bio: bio);
    }
    return Artist(name: name,
        id: id,
        gender: gender,
        portrait: portrait,
        age: age,
        bio: bio);
  }

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

  static Future<Person> getPersonLoggedInOnDevice() async {
    if (!await deviceIsLoggedIn()) throw Exception('Device is not logged in');
    if (_personLoggedIn != null) return _personLoggedIn!;
    Future<Person> person = http.get(Uri.parse(
      'http://$fhlIP/api/profiles/'
    ),
        headers: <String, String> {
      'Content-Type' : 'application/json; charset=UTF-8',
          'Authorization' : 'Token ${await getToken()}'
        }
    ).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> videoJson = jsonDecode(response.body);
        return Person.fromProfileJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user ' + jsonDecode(response.body).toList().keys[0] + ' '
            + jsonDecode(response.body).toList().values[0]);
      }
    }
    );
    _personLoggedIn = person;
    return person;
  }

  Future<List<Video>> getLikedVideos() async {
    final response = await http.get(
      Uri.parse('http://$fhlIP/api/videos/get_videos_liked_by_user/?user_id=$_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> videoJson = jsonDecode(response.body);
      return videoJson.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos: ${response.body}');
    }
  }
  Future<List<Video>> getCreatedVideos() async {
    final response = await http.get(
      Uri.parse('http://$fhlIP/api/videos/get_videos_by_user/?user_id=$_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> videoJson = jsonDecode(response.body);
      return videoJson.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos: ${response.body}');
    }
  }

}

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

import '../Utilities/api_service.dart';

enum Gender { Male, Female, Mysterious }

/// An abstract class representing a person in the application.
///
/// This class implements the [Name] interface and provides common functionality
/// for different types of users in the system.
abstract class Person implements Name {
  String _name;
  late final int _id;
  Gender _gender;
  int? _age;
  Image _portrait;
  String _bio;
  static Future<Person>? _personLoggedIn;

  /// Creates a [Person] instance.
  ///
  /// Parameters:
  /// - [name]: The name of the person.
  /// - [id]: The unique identifier for the person.
  /// - [gender]: The gender of the person.
  /// - [portrait]: The person's portrait or avatar.
  /// - [bio]: A short biography or description of the person.
  /// - [age]: The age of the person (optional).
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
        _bio = bio;

  /// Gets the biography of the person.
  String get bio => _bio;

  /// Creates a [Person] instance from a JSON string.
  ///
  /// This factory method creates either a [NormalUser] or an [Artist] based on the JSON data.
  ///
  /// Parameters:
  /// - [json]: A JSON string containing the person's data.
  ///
  /// Returns a [Person] object (either [NormalUser] or [Artist]).
  factory Person.fromProfileJson(String json) {
    Map jsonMap = jsonDecode(json);
    String name = jsonMap['username'] ?? 'unknown';
    int id = jsonMap['id'] ?? '0';
    Gender gender = Gender.Mysterious;
    Image portrait = jsonMap['portrait'] ?? Image.asset('assets/images/pf.jpg');
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

  /// Sets the name of the person.
  @override
  void setName(String s) {
    _name = s;
  }

  /// Sets the gender of the person.
  void setGender(Gender g) {
    _gender = g;
  }

  /// Sets the age of the person.
  void setAge(int a) {
    _age = a;
  }

  /// Sets the portrait of the person.
  void setPortrait(Image i) {
    _portrait = i;
  }

  /// Gets the name of the person.
  @override
  String getName() => _name;

  /// Gets the gender of the person.
  Gender getGender() {
    return _gender;
  }

  /// Gets the age of the person.
  int? getAge() => _age;

  /// Gets the portrait of the person.
  Image getPortrait() => _portrait;

  /// Gets the ID of the person.
  int getId() => _id;

  /// Makes this person follow another person.
  ///
  /// Parameters:
  /// - [p]: The person to follow.
  void follow(Person p) {
    FollowerManager.addToFollowing(this, p);
  }

  /// Makes this person unfollow another person.
  ///
  /// Parameters:
  /// - [p]: The person to unfollow.
  void unfollow(Person p) {
    FollowerManager.removeFromFollowing(this, p);
  }

  /// Deletes this person from the system.
  void delete() {
    FollowerManager.deletePerson(this);
  }

  /// Checks if a user is logged in on the device.
  ///
  /// Returns a [Future<bool>] indicating whether a user is logged in.
  static Future<bool> deviceIsLoggedIn() async {
    return (SharedPreferences.getInstance()).then((sp) { return sp.getString('token')!.isEmpty;});
  }

  /// Gets the authentication token for the logged-in user.
  ///
  /// Returns a [Future<String>] containing the authentication token.
  static Future<String> getToken() {
    return (SharedPreferences.getInstance()).then((sp) { return sp.getString('token')!;});
  }

  /// Gets the [Person] object for the user logged in on the device.
  ///
  /// Returns a [Future<Person>] representing the logged-in user.
  /// Throws an exception if no user is logged in.
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

  /// Retrieves the list of videos liked by this person.
  ///
  /// Returns a [Future<List<Video>>] containing the liked videos.
  /// Throws an exception if the request fails.
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

  /// Retrieves the list of videos created by this person.
  ///
  /// Returns a [Future<List<Video>>] containing the created videos.
  /// Throws an exception if the request fails.
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

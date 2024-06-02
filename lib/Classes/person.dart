
import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/Name.dart';
import 'package:spoplusplusfy/Classes/follower_manager.dart';
import 'package:spoplusplusfy/Classes/person.dart';

enum Gender {Male, Female, Mysterious}

abstract class Person implements Name {

  String _name;
  late int _id;
  Gender _gender;
  int? _age;
  Image _portrait;

  Person({
    required String name,
    required int id,
    required Gender gender,
    required Image portrait,
  }) : this._name = name,
      this._id = id,
      this._gender = gender,
      this._portrait = portrait;

  @override
  String getName() {
    return _name;
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


  Gender getGender() {
    return _gender;
  }

  int? getAge() {
    return _age;
  }

  Image getPortrait() {
    return _portrait;
  }

  void follow(Person p) {
    FollowerManager.addToFollowing(this, p);
  }

  void unfollow(Person p) {
    FollowerManager.removeFromFollowing(this, p);
  }

  void delete() {
    FollowerManager.deletePerson(this);
  }
}
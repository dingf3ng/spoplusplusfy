import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/person.dart';

enum Gender { Male, Female, Mysterious }

class Person {
  String _name;
  late int _id;
  String _gender;
  int? _age;
  Image _portrait;

  Person({
    required String name,
    required int id,
    required String gender,
    required Image portrait,
  })  : this._name = name,
        this._id = id,
        this._gender = gender,
        this._portrait = portrait;

  void setName(String s) {
    _name = s;
  }

  void setGender(String g) {
    _gender = g;
  }

  void setAge(int a) {
    _age = a;
  }

  void setPortrait(Image i) {
    _portrait = i;
  }

  String getName() {
    return _name;
  }

  String getGender() {
    return _gender;
  }

  int? getAge() {
    return _age;
  }

  Image getPortrait(Image i) {
    return _portrait;
  }

  void follow(Person p) {}

  void delete() {}
}

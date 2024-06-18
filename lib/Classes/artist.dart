import 'dart:math';

import 'package:spoplusplusfy/Classes/name.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:flutter/material.dart';

class Artist extends Person implements Name{

  //temp id
  static int id = 1;

  Artist({
    required super.name,
    required super.id,
    required super.gender,
    required super.portrait,
    super.age,
  });

  factory Artist.fromMap(Map<String, Object?> map) {
    return Artist(
        name: map['artist_name'] as String,
        id: id ++,
        gender: Gender.Mysterious,
        portrait: _getRandom(),
    );
  }
  // TODO:

  static _getRandom() {
    Random random = Random();
    int t = random.nextInt(3);
    if(t == 0) {
      return const Image(image: AssetImage('assets/images/prince.jpg'));
    }
    else if(t == 1) {
      return const Image(image: AssetImage('assets/images/pf.jpg'));
    }
    else {
      return const Image(image: AssetImage('assets/images/artist_portrait.jpg'));
    }

  }
  // @override
  // void delete() {
  //   super.delete();
  //   ArtistWorksManager.deleteArtist(this);
  // }

}
import 'package:spoplusplusfy/Classes/Name.dart';
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
        portrait: const Image(image: AssetImage('assets/images/prince.jpg')),
    );
  }

  // @override
  // void delete() {
  //   super.delete();
  //   ArtistWorksManager.deleteArtist(this);
  // }

}
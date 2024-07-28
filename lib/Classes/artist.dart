import 'dart:math';

import 'package:spoplusplusfy/Classes/name.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:flutter/material.dart';

/// Represents an artist in the music application.
///
/// This class extends [Person] and implements [Name], providing functionality
/// specific to artists. It includes properties such as name, id, gender,
/// portrait, age, and bio.
class Artist extends Person implements Name {
  /// A static counter for generating temporary IDs.
  static int id = 1;

  /// Creates an [Artist] instance.
  ///
  /// Parameters:
  /// - [name]: The name of the artist.
  /// - [id]: The unique identifier for the artist.
  /// - [gender]: The gender of the artist.
  /// - [portrait]: The portrait image of the artist.
  /// - [age]: The age of the artist (optional).
  /// - [bio]: A biography of the artist.
  Artist({
    required super.name,
    required super.id,
    required super.gender,
    required super.portrait,
    super.age,
    required super.bio,
  });

  /// Creates an [Artist] instance from a map of key-value pairs.
  ///
  /// The map should contain the following keys:
  /// - 'artist_name': The name of the artist (String).
  /// - 'bio': The biography of the artist (String, optional).
  ///
  /// This factory method generates a temporary ID and sets a random portrait.
  factory Artist.fromMap(Map<String, Object?> map) {
    return Artist(
      name: map['artist_name'] as String,
      id: id++,
      gender: Gender.Mysterious,
      portrait: _getRandom(),
      bio: (map['bio'] ?? '') as String,
    );
  }

  /// Generates a random portrait image for the artist.
  ///
  /// Returns one of three predefined images:
  /// - 'assets/images/prince.jpg'
  /// - 'assets/images/pf.jpg'
  /// - 'assets/images/artist_portrait.jpg'
  static _getRandom() {
    Random random = Random();
    int t = random.nextInt(3);
    if (t == 0) {
      return const Image(image: AssetImage('assets/images/prince.jpg'));
    } else if (t == 1) {
      return const Image(image: AssetImage('assets/images/pf.jpg'));
    } else {
      return const Image(
          image: AssetImage('assets/images/artist_portrait.jpg'));
    }
  }

// TODO: Implement additional methods or properties as needed.

// Uncomment and implement the delete method if needed:
// @override
// void delete() {
//   super.delete();
//   ArtistWorksManager.deleteArtist(this);
// }
}
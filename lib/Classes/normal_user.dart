import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:http/http.dart' as http;
import 'package:spoplusplusfy/Classes/song.dart';

/// Represents a normal user in the application.
///
/// This class extends [Person] and represents a standard user account.
/// It includes all the properties of a [Person] and adds functionality
/// specific to normal users.
class NormalUser extends Person {
  /// Creates a [NormalUser] instance.
  ///
  /// Parameters:
  /// - [name]: The name of the user.
  /// - [id]: The unique identifier for the user.
  /// - [gender]: The gender of the user.
  /// - [portrait]: The user's portrait or avatar.
  /// - [age]: The age of the user.
  /// - [bio]: A short biography or description of the user.
  NormalUser({
    required super.name,
    required super.id,
    required super.gender,
    required super.portrait,
    required super.age,
    required super.bio
  });

  /// Represents the currently logged-in user.
  ///
  /// This static property holds a reference to the [NormalUser] instance
  /// that represents the current user of the application.
  static late NormalUser currentUser;
}
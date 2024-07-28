import 'dart:core';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:spoplusplusfy/Classes/song.dart';

/// An abstract class representing a playlist in the music application.
///
/// This class implements the [Name] interface and provides common functionality
/// for different types of playlists in the system.
abstract class Playlist implements Name {
  String _name;
  late final String _playlistCoverImagePath;
  late final int _id;
  int _timeLength = 0;
  late final bool _mutable;

  /// Creates a [Playlist] instance.
  ///
  /// Parameters:
  /// - [name]: The name of the playlist.
  /// - [playlistCoverPath]: The path to the playlist's cover image.
  /// - [id]: The unique identifier for the playlist.
  /// - [timeLength]: The total duration of the playlist in seconds (optional).
  /// - [mutable]: Whether the playlist can be modified.
  Playlist(
      {required String name,
        required String playlistCoverPath,
        required int id,
        int? timeLength,
        required bool mutable})
      : _name = name,
        _playlistCoverImagePath = playlistCoverPath,
        _id = id,
        _timeLength = timeLength ?? 0,
        _mutable = mutable;

  /// Gets the hash code for the playlist.
  ///
  /// Returns an [int] representing the hash code of the playlist's ID.
  int getHashCode() {
    return _id.hashCode;
  }

  /// Gets the cover image path for the playlist.
  ///
  /// Returns a [String] representing the path to the playlist's cover image.
  String getCoverPath() {
    return _playlistCoverImagePath;
  }

  /// Gets the name of the playlist.
  ///
  /// Returns a [String] representing the name of the playlist.
  @override
  String getName() {
    return _name;
  }

  /// Sets the name of the playlist.
  ///
  /// Parameters:
  /// - [newName]: The new name for the playlist.
  @override
  void setName(String newName) {
    _name = newName;
  }

  /// Updates the playlist with a new song.
  ///
  /// This method increases the total duration of the playlist by adding the duration of the new song.
  ///
  /// Parameters:
  /// - [song]: The [Song] to be added to the playlist.
  void updateWith(Song song) {
    _timeLength += song.getDuration();
  }

  /// Deletes the playlist.
  ///
  /// This is an abstract method that should be implemented by subclasses to provide
  /// specific deletion behavior.
  void delete();

  /// Gets the total duration of the playlist.
  ///
  /// Returns an [int] representing the total duration of the playlist in seconds.
  int? timeLength() {
    return _timeLength;
  }

  /// Checks if the playlist is mutable.
  ///
  /// Returns a [bool] indicating whether the playlist can be modified.
  bool isMutable() {
    return _mutable;
  }

  /// Gets the unique identifier of the playlist.
  ///
  /// Returns an [int] representing the unique ID of the playlist.
  int getId() {
    return _id;
  }
}

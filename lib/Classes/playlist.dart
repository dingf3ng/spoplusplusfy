import 'dart:core';
import 'package:spoplusplusfy/Classes/name.dart';
import 'package:spoplusplusfy/Classes/song.dart';

abstract class Playlist implements Name {
  String _name;
  late final String _playlistCoverImagePath;
  late final int _id;
  int _timeLength = 0;
  late final bool _mutable;

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

  int getHashCode() {
    return _id.hashCode;
  }

  String getCoverPath() {
    return _playlistCoverImagePath;
  }

  @override
  String getName() {
    return _name;
  }

  @override
  void setName(String newName) {
    _name = newName;
  }

  void updateWith(Song song) {
    _timeLength += song.getDuration();
  }

  void delete();

  int? timeLength() {
    return _timeLength;
  }

  bool isMutable() {
    return _mutable;
  }

  int getId() {
    return _id;
  }
}

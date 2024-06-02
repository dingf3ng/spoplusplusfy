import 'dart:core';
import 'package:spoplusplusfy/Classes/Name.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

abstract class Playlist implements Name{
  String _name;
  late String _playlistCoverImagePath;
  late int _id;
  int _timeLength;
  late bool _mutable;

  Playlist(
      {required String name,
      required String playlistCoverPath,
      required int id,
      required int timelength,
      required bool mutable})
      : _name = name,
        _playlistCoverImagePath = playlistCoverPath,
        _id = id,
        _timeLength = timelength,
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

  int length() {
    return _timeLength;
  }

  bool isMutable() {
    return _mutable;
  }
}

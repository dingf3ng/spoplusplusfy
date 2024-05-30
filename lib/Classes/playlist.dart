import 'dart:core';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';

class Playlist {
  late String _name;
  late String _playlistCoverImagePath;
  late int _id;
  late int _timeLength;
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

  void delete() {
    try {
      PlaylistSongManager.deletePlaylist(this);
    } on Exception catch (e) {}
  }

  int length() {
    return _timeLength;
  }

  bool isMutable() {
    return _mutable;
  }

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }
}

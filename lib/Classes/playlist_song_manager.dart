import 'dart:collection';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class PlaylistSongManager {
  static final HashMap<Playlist, List<Song>> _listMap = HashMap();
  static final HashMap<Song, List<Playlist>> _songMap = HashMap();
  static final HashSet<Playlist> _validPlaylist = HashSet();
  static final HashSet<Song> _validSong = HashSet();

  PlaylistSongManager._privateConstructor();

  static Future<void> init(
    List<Album> albums,
    List<Song> songs,
    HashMap<int, Album> id2Album,
    HashMap<int, Song> id2Song,
    List<Map<String, Object?>>? songs2Albums,
  ) async {
    for (Map<String, Object?> relationship in songs2Albums!) {
      int? songId = int.parse(relationship['field1'] as String);
      int? albumId = int.parse(relationship['field5'] as String);
      if (!id2Album.containsKey(albumId)) continue;
      _listMap.update(id2Album[albumId]!, (list) => list..add(id2Song[songId]!),
          ifAbsent: () => [id2Song[songId]!]);
      _songMap.update(id2Song[songId]!, (list) => list..add(id2Album[albumId]!),
          ifAbsent: () => [id2Album[albumId]!]);
    }
  }

  static List<Song> getSongsForPlaylist(Playlist playlist) {
    if (_listMap[playlist] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    return _listMap[playlist]!
      ..removeWhere((song) => !_validSong.contains(song));
  }

  static void addSongToPlayList(Song song, Playlist playlist) {
    if (!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    _listMap.update(playlist, (list) => list..add(song),
        ifAbsent: () => [song]);
  }

  static void deleteSongFromPlaylist(Song song, Playlist playlist) {
    if (!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    if (_listMap[playlist] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _listMap.update(playlist, (list) => list..remove(song));
    if (_listMap[playlist]!.isEmpty) {
      deletePlaylist(playlist);
    }
  }

  static void deletePlaylist(Playlist playlist) {
    if (!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    _validPlaylist.remove(playlist);
    _listMap.remove(playlist);
    //TO DO: remove in database
  }

  static List<Playlist> getPlaylistsForSong(Song song) {
    if (_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    // lazy delete
    return _songMap[song]!
      ..removeWhere((playlist) => !_validPlaylist.contains(playlist));
  }

  static void addPlaylistToSong(Song song, Playlist playlist) {
    if (_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _songMap[song]!.add(playlist);
  }

  static void deletePlaylistFromSong(Song song, Playlist playlist) {
    if (_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _songMap[song]!.remove(playlist);
  }

  static void deleteSong(Song song) {
    _validSong.remove(song);
    _songMap.remove(song);
  }

  static bool checkValidSong(Song song) {
    return _validSong.contains(song);
  }

  static bool checkValidPlaylist(Playlist playlist) {
    return _validPlaylist.contains(playlist);
  }
}

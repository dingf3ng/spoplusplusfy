
import 'dart:collection';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class PlaylistSongManager {
  static late HashMap<Playlist, List<Song>> _listMap;
  static late HashMap<Song, List<Playlist>> _songMap;
  static late HashSet<Playlist> _allValidPlaylist;
  static late HashSet<Song> _allValidSong;

  PlaylistSongManager._privateConstructor();
  
  static PlaylistSongManager init(HashSet<Playlist> validPlaylist,
      HashSet<Song> validSong,
      HashMap<Playlist, List<Song>> listMap,
      HashMap<Song, List<Playlist>> songMap,
      ) {
    _allValidPlaylist = validPlaylist;
    _allValidSong = validSong;
    _listMap = listMap;
    _songMap = songMap;
    return PlaylistSongManager._privateConstructor();
  }

  static Future<List<Song>> getSongsForPlaylist(Playlist playlist) async {
    // if(_listMap[playlist] == null) {
    //   throw 'Error by manipulating a element does not exist';
    // }
    // TODO: check if this is ok to write like this
    return DatabaseHelper().getSongsForPlaylist(playlist);
    // return _listMap[playlist]!..removeWhere(
    //         (song) => !_allValidSong.contains(song)
    // );
  }

  static void addSongToPlayList(Song song, Playlist playlist) {
    if(!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    _listMap.update(
        playlist,  (list) => list..add(song), ifAbsent: () => [song]
    );
  }

  static void deleteSongFromPlaylist(Song song, Playlist playlist) {
    if(!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    if(_listMap[playlist] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _listMap.update(playlist, (list) => list..remove(song));
    if(_listMap[playlist]!.isEmpty) {
      deletePlaylist(playlist);
    }
  }

  static void deletePlaylist (Playlist playlist){
    if(!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    _allValidPlaylist.remove(playlist);
    _listMap.remove(playlist);
    //TO DO: remove in database
  }

  static List<Playlist> getPlaylistsForSong(Song song) {
    if(_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    // lazy delete
    return _songMap[song]!..removeWhere(
            (playlist) => !_allValidPlaylist.contains(playlist)
    );
  }

  static void addPlaylistToSong(Song song, Playlist playlist) {
    if(_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _songMap[song]!.add(playlist);
  }

  static void deletePlaylistFromSong(Song song, Playlist playlist) {
    if(_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _songMap[song]!.remove(playlist);
  }

  static void deleteSong(Song song) {
    _allValidSong.remove(song);
    _songMap.remove(song);
  }

  static bool checkValidSong(Song song) {
    return _allValidSong.contains(song);
  }

  static bool checkValidPlaylist(Playlist playlist) {
    return _allValidPlaylist.contains(playlist);
  }
}
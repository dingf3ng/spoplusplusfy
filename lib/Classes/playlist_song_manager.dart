
import 'dart:collection';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:sqflite/sqflite.dart';

class PlaylistSongManager {
  static late HashMap<Playlist, List<Song>> _listMap = HashMap();
  static late HashMap<Song, List<Playlist>> _songMap = HashMap();
  static late HashSet<Playlist> _allValidPlaylist = HashSet();
  static late HashSet<Song> _allValidSong = HashSet();

  static HashMap<int, Album> Id2Album = HashMap();
  static HashMap<int, Song> Id2Song = HashMap();
  static List<Album> albums = [];
  static List<Song> songs = [];

  PlaylistSongManager._privateConstructor();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  static void addSongsAndAlbums(List<Album> als, List<Song> sos, HashMap<int, Album> idAlbum,
  HashMap<int, Song> idSong) {
    _allValidSong.addAll(sos);
    _allValidPlaylist.addAll(als);
    Id2Song = idSong;
    Id2Album = idAlbum;
    albums = als;
    songs = sos;
  }

  static Future<void> init() async{
    final Database? db = await DatabaseHelper.database;

    //load relationships
    for(Album album in albums) {
      Id2Album.putIfAbsent(album.getId(), () => album);
    }
    for(Song song in songs) {
      Id2Song.putIfAbsent(song.getId(), () => song);
    }
    final List<Map<String,Object?>>? relationships = await db?.query('combined_songs_albums');
    for(Map<String, Object?> relationship in relationships!) {
      int? songId = int.parse(relationship['field1'] as String);
      int? albumId = int.parse(relationship['field5'] as String);
      if(!Id2Album.containsKey(albumId)) continue;
      _listMap.update(Id2Album[albumId]!, (list) => list..add(Id2Song[songId]!),
          ifAbsent: () => [Id2Song[songId]!]);
      _songMap.update(Id2Song[songId]!, (list) => list..add(Id2Album[albumId]!),
          ifAbsent: () => [Id2Album[albumId]!]);
    }
  }

  static List<Song> getSongsForPlaylist(Playlist playlist) {
    if(_listMap[playlist] == null) {
       throw 'Error by manipulating a element does not exist';
    }
    // TODO: check if this is ok to write like this
    //return DatabaseHelper().getSongsForPlaylist(playlist);
    return _listMap[playlist]!..removeWhere(
            (song) => !_allValidSong.contains(song)
    );
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
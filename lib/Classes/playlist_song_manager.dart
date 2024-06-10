
import 'dart:collection';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:sqflite/sqflite.dart';

class PlaylistSongManager {
  static late HashMap<Playlist, List<Song>> _listMap;
  static late HashMap<Song, List<Playlist>> _songMap;
  static late HashSet<Playlist> _allValidPlaylist;
  static late HashSet<Song> _allValidSong;

  PlaylistSongManager._privateConstructor();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  static Future<void> init() async{
    final Database? db = await DatabaseHelper.database;
    // init all the maps and sets
    _listMap = HashMap();
    _songMap = HashMap();
    _allValidPlaylist = HashSet();
    _allValidSong = HashSet();

    HashMap<int, Album> Id2Album = HashMap();
    HashMap<int, Song> Id2Song = HashMap();

    // read data from db
    //read album
    final List<Map<String,Object?>>? albumMaps = await db?.query('updated_album_database');
    final List<Album> albums = albumMaps!.map((map) => Album.fromMap(map)).toList();
    //TODO: read created playlists
    _allValidPlaylist.addAll(albums);

    //read song
    final List<Map<String, Object?>>? songMaps = await db?.query('songs');
    final List<Song> songs = songMaps!.map((map) => Song.fromMap(map)).toList();
    _allValidSong.addAll(songs);

    //load relationships
    for(Album album in albums) {
      Id2Album.putIfAbsent(album.getId(), () => album);
    }
    for(Song song in songs) {
      Id2Song.putIfAbsent(song.getId(), () => song);
    }
    final List<Map<String,Object?>>? relationships = await db?.query('combined_songs_albums');
    for(Map<String, Object?> relationship in relationships!) {
      int? song_id = relationship['field1'] as int?;
      int? album_id = relationship['field5'] as int?;
      _listMap.update(Id2Album[album_id]!, (list) => list..add(Id2Song[song_id]!),
          ifAbsent: () => [Id2Song[song_id]!]);
      _songMap.update(Id2Song[song_id]!, (list) => list..add(Id2Album[album_id]!),
          ifAbsent: () => [Id2Album[album_id]!]);
    }
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
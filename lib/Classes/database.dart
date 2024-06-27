import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'album.dart';
import 'artist.dart';
import 'playlist.dart';

/// A singleton class that helps in managing the SQLite database.
class DatabaseHelper {
  /// Private constructor for singleton implementation.
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  /// Factory constructor that returns the same instance of [DatabaseHelper].
  factory DatabaseHelper() => _instance;

  /// SQLite database instance.
  static Database? _database;

  DatabaseHelper._internal();

  /// Getter for the database instance.
  /// If the database is already initialized, it returns the existing instance,
  /// otherwise, it initializes the database and returns the new instance.
  static Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database.
  /// Checks if the database already exists, if not, it copies the database from assets.
  static Future<Database?> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'spo++fy_database.db');

    // Check if the database exists
    // If it doesn't exist, copy it from the assets
    ByteData data =
        await rootBundle.load('assets/database/spo++fy_database.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);

    return openDatabase(path, version: 1);
  }

  static Future<void> initializeFrontendData() async {
    await database;
    await _loadFromDatabase();
  }

  static Future<void> _loadFromDatabase() async {
    // read data from db
    // read album
    final List<Map<String, Object?>>? albumMaps =
        await _database?.query('updated_album_database');
    final List<Album> albums =
        albumMaps!.map((map) => Album.fromMap(map)).toList();

    // read song
    final List<Map<String, Object?>>? songMaps =
        await _database?.query('songs');
    final List<Song> songs = songMaps!.map((map) => Song.fromMap(map)).toList();

    // read artist
    final List<Map<String, Object?>>? artistMap = await _database?.query(
      'songs',
      columns: ['artist_name'],
      distinct: true,
    );
    final List<Artist> artists =
        artistMap!.map((map) => Artist.fromMap(map)).toList();

    final List<Map<String, Object?>>? songs2Albums =
        await _database?.query('combined_songs_albums');

    // create the mapping of instances' ID to themselves
    HashMap<int, Album> id2Album = HashMap();
    HashMap<int, Song> id2Song = HashMap();
    HashMap<String, Artist> name2Artist = HashMap();
    for (Album album in albums) {
      id2Album.putIfAbsent(album.getId(), () => album);
    }
    for (Song song in songs) {
      id2Song.putIfAbsent(song.getId(), () => song);
    }
    for (Artist artist in artists) {
      name2Artist.putIfAbsent(artist.getName(), () => artist);
    }

    // call _initManager method to initialize the data managers
    await _initManagers(albums, songs, artists, id2Album, id2Song, name2Artist,
        songMaps, songs2Albums);
  }

  static Future<void> _initManagers(
    List<Album> albums,
    List<Song> songs,
    List<Artist> artists,
    HashMap<int, Album> id2Album,
    HashMap<int, Song> id2Song,
    HashMap<String, Artist> name2Artist,
    List<Map<String, Object?>>? relationships,
    List<Map<String, Object?>>? songs2Albums,
  ) async {
    //Init AWM
    await ArtistWorksManager.init(
        albums, songs, artists, id2Album, id2Song, name2Artist, relationships);
    //Init PSM
    await PlaylistSongManager.init(
        albums, songs, id2Album, id2Song, songs2Albums);
    //Init Search Engine
    SearchEngine.init(
        artists.toSet(), albums.toSet(), {}, songs.toSet(), HashSet());
  }

  /// Retrieves a random playlist from the database.
  ///
  /// Queries the database for all playlists and selects one at random.
  /// Returns a [Playlist] object.
  /// Throws an exception if no playlists are available.
  @Deprecated('try to use "ArtistWorkManager::getRandomPlaylist" instead')
  Future<Playlist> getRandomPlaylist() async {
    return ArtistWorksManager.getRandomPlaylist();
  }
}

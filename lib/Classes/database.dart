import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoplusplusfy/Classes/Artist.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'playlist.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database?> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'spo++fy_database.db');

    // Check if the database exists
    if (!await File(path).exists()) {
      // If it doesn't exist, copy it from the assets
      ByteData data = await rootBundle.load('assets/database/spo++fy_database.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    return openDatabase(path, version: 1);
  }

  Future<List<Song>> getSongsForPlaylist(Playlist playlist) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'songs',
      where: 'album_id=?',
      whereArgs: [playlist.getId()],
    );
    List<int> songIds = maps.map((e) => e['id'] as int).toList();
    final List<Map<String, dynamic>> songs = await db.query(
      'songs',
      where: 'id IN (${songIds.join(',')})',
    );

    return List.generate(songs.length, (i) {
      Artist artist = Artist(
        name: songs[i]['artist']??'no_name',
        id: 111,
        gender: Gender.Mysterious,
        portrait: Image.asset('assets/images/artist_portrait.jpg'),
      );
      return Song(
        songs[i]['song_id']??000,
        songs[i]['duration']??000,
        songs[i]['name']??'no_name',
        artist,
        playlist,
        false,
      );
    });
  }

  Future<Playlist> getRandomPlaylist() async {
    final db = await database;
    final List<Map<String, dynamic>> playlists = await db!.query('albums');
    if (playlists.isEmpty) {
      throw Exception('No playlists available');
    }
    final randomIndex = Random().nextInt(playlists.length);
    final playlistData = playlists[randomIndex];
    return Playlist(
      name: playlistData['name']??'no_name',
      playlistCoverPath: 'assets/images/playlist_cover.jpg',
      id: playlistData['album_id']??000,
      timelength: playlistData['duration']??0,
      mutable: false,
    );
  }
}

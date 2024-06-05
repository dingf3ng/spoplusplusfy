/*
import 'package:flutter_test/flutter_test.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    // Initialize sqflite for FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  DatabaseHelper databaseHelper = DatabaseHelper();

  setUp(() async {


  });

  test('Get Random Playlist', () async {
    final playlist = await databaseHelper.getRandomPlaylist();

    // Print results
    print('Random Playlist:');
    print('ID: ${playlist.getId()}, Name: ${playlist.getName()}, Duration: ${0}');
  });
  test('Get Songs For Playlist', () async {
    final playlist = Playlist(name: 'Test Playlist', id: 1, playlistCoverPath: 'path', timelength: 120, mutable: false);

    final songs = await databaseHelper.getSongsForPlaylist(playlist);

    // Print results
    print('Songs for Playlist:');
    for (var song in songs) {
      print('ID: ${song.getId()}, Name: ${song.getName()}, Artist: ${'ji'}');
    }
  });
}
 */

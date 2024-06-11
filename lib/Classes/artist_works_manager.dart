
import 'dart:collection';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';

class ArtistWorksManager {

  static late HashMap<Artist, List<Song>> _artistSongMap;
  static late HashMap<Artist, List<Album>> _artistAlbumMap;
  static late HashMap<Song, List<Artist>> _songArtistMap;
  static late HashMap<Album, List<Artist>> _albumArtistMap;

  static late HashSet<Song> _validSongs;
  static late HashSet<Album> _validAlbums;
  static late HashSet<Artist> _validArtists;

  ArtistWorksManager._private();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<void> init() async {
    final Database? db = await DatabaseHelper.database;
    _artistSongMap = HashMap();
    _artistAlbumMap = HashMap();
    _songArtistMap = HashMap();
    _albumArtistMap = HashMap();
    _validSongs = HashSet();
    _validAlbums = HashSet();
    _validArtists = HashSet();

    HashMap<int, Album> Id2Album = HashMap();
    HashMap<int, Song> Id2Song = HashMap();
    HashMap<String, Artist> Id2Artist = HashMap();

    // read data from db
    //read album
    final List<Map<String,Object?>>? albumMaps = await db?.query('updated_album_database');
    final List<Album> albums = albumMaps!.map((map) => Album.fromMap(map)).toList();
    _validAlbums.addAll(albums);

    //read song
    final List<Map<String, Object?>>? songMaps = await db?.query('songs');
    final List<Song> songs = songMaps!.map((map) => Song.fromMap(map)).toList();
    _validSongs.addAll(songs);

    //read artist
    final List<Map<String, Object?>>? artistMap = await db?.query(
        'songs',
      columns: ['artist_name'],
      distinct: true,
    );
    final List<Artist> artists = artistMap!.map((map) => Artist.fromMap(map)).toList();
    _validArtists.addAll(artists);

    SearchEngine.init(artists.toSet(), albums.toSet(), {}, songs.toSet(), HashSet());

    for(Album album in albums) {
      Id2Album.putIfAbsent(album.getId(), () => album);
    }
    for(Song song in songs) {
      Id2Song.putIfAbsent(song.getId(), () => song);
    }
    for(Artist artist in artists) {
      Id2Artist.putIfAbsent(artist.getName(), () => artist);
    }


  }

  static List<Artist> getArtistsOfSong(Song song) {
    return _songArtistMap[song]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  static String getArtistsOfSongAsString(Song song) {
    return getArtistsOfSong(song).map((artist) => artist.getName())
        .reduce((value,element) => '$value, $element');
  }

  static List<Artist> getArtistsOfAlbum(Album album) {
    return _albumArtistMap[album]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  static String getArtistsOfAlbumAsString(Album album) {
    return getArtistsOfAlbum(album).map((artist) => artist.getName())
        .reduce((value,element) => '$value, $element');
  }

  static List<Song> getSongsOfArtist(Artist artist) {
    return _artistSongMap[artist]!..removeWhere((x) => !_validSongs.contains(x));
  }

  static List<Album> getAlbumsOfArtist(Artist artist) {
    return _artistAlbumMap[artist]!..removeWhere((x) => !_validSongs.contains(x));
  }

  static void addSongForArtist(Artist artist, Song song) {
    _artistSongMap.update(
        artist,  (artist) => artist..add(song), ifAbsent: () => [song]
    );
    _songArtistMap.update(song, (song) => song..add(artist), ifAbsent: () => [artist]);
  }

  static void addAlbumForArtist(Artist artist, Album album) {
    _artistAlbumMap.update(
        artist,  (artist) => artist..add(album), ifAbsent: () => [album]
    );
    _albumArtistMap.update(album, (album) => album..add(artist), ifAbsent: () => [artist]);
  }

  static void deleteArtist(Artist artist) {
    _validArtists.remove(artist);
  }

  static void deleteAlbum(Album album) {
    _validAlbums.remove(album);
  }

  static void deleteSong(Song song) {
    _validSongs.remove(song);
  }

  static void addArtist(Artist artist) {
    _validArtists.add(artist);
  }

  static void addAlbum(Album album) {
    _validAlbums.add(album);
  }

  static void addSong(Song song) {
    _validSongs.add(song);
  }

}
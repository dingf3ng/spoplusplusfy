import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class ArtistWorksManager {
  static final HashMap<Artist, List<Song>> _artistSongMap = HashMap();
  static final HashMap<Artist, List<Album>> _artistAlbumMap = HashMap();
  static final HashMap<Song, List<Artist>> _songArtistMap = HashMap();
  static final HashMap<Album, List<Artist>> _albumArtistMap = HashMap();

  static final HashSet<Song> _validSongs = HashSet();
  static final HashSet<Album> _validAlbums = HashSet();
  static final HashSet<Artist> _validArtists = HashSet();

  ArtistWorksManager._private();

  static Future<void> init(
    List<Album> albums,
    List<Song> songs,
    List<Artist> artists,
    HashMap<int, Album> id2Album,
    HashMap<int, Song> id2Song,
    HashMap<String, Artist> name2Artist,
    List<Map<String, Object?>>? relationships,
  ) async {
    // add valid instances
    _validAlbums.addAll(albums);
    _validSongs.addAll(songs);
    _validArtists.addAll(artists);

    // construct relationships
    HashSet<Album> added = HashSet();
    for (Map<String, Object?> relationship in relationships!) {
      Artist artist = name2Artist[relationship['artist_name']]!;
      Song song = id2Song[relationship['song_id']]!;
      Album album = id2Album[relationship['album_id']]!;

      if (!added.contains(album)) {
        _artistAlbumMap.update(artist, (list) => list..add(album),
            ifAbsent: () => [album]);
      }
      _artistSongMap.update(artist, (list) => list..add(song),
          ifAbsent: () => [song]);
      _songArtistMap.update(song, (list) => list..add(artist),
          ifAbsent: () => [artist]);
      if (!added.contains(album)) {
        _albumArtistMap.update(album, (list) => list..add(artist),
            ifAbsent: () => [artist]);
      }
      added.add(album);
    }
  }

  static Playlist getRandomPlaylist() {
    final randomSeed = Random().nextInt(1000000);
    final randomIndex = Random(randomSeed).nextInt(_validAlbums.length);
    return _validAlbums.elementAt(randomIndex);
  }

  static List<Artist> getArtistsOfSong(Song song) {
    if (!_songArtistMap.containsKey(song)) {
      return [
        Artist(
            name: 'a',
            id: 000,
            gender: Gender.Mysterious,
            portrait: const Image(
              image: AssetImage(''),
            ))
      ];
    }
    return _songArtistMap[song]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  static String getArtistsOfSongAsString(Song song) {
    return getArtistsOfSong(song)
        .map((artist) => artist.getName())
        .reduce((value, element) => '$value, $element');
  }

  static List<Artist> getArtistsOfAlbum(Album album) {
    return _albumArtistMap[album]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  static String getArtistsOfAlbumAsString(Album album) {
    return getArtistsOfAlbum(album)
        .map((artist) => artist.getName())
        .reduce((value, element) => '$value, $element');
  }

  static List<Song> getSongsOfArtist(Artist artist) {
    if (_artistSongMap[artist] == null) return [];
    return _artistSongMap[artist]!
      ..removeWhere((x) => !_validSongs.contains(x));
  }

  static List<Album> getAlbumsOfArtist(Artist artist) {
    if (_artistAlbumMap[artist] == null) return [];
    return _artistAlbumMap[artist]!
      ..removeWhere((x) => !_validAlbums.contains(x));
  }

  static void addSongForArtist(Artist artist, Song song) {
    _artistSongMap.update(artist, (artist) => artist..add(song),
        ifAbsent: () => [song]);
    _songArtistMap.update(song, (song) => song..add(artist),
        ifAbsent: () => [artist]);
  }

  static void addAlbumForArtist(Artist artist, Album album) {
    _artistAlbumMap.update(artist, (artist) => artist..add(album),
        ifAbsent: () => [album]);
    _albumArtistMap.update(album, (album) => album..add(artist),
        ifAbsent: () => [artist]);
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

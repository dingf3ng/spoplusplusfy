import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

/// Manages relationships between artists, songs, and albums in the music application.
///
/// This class provides methods for initializing and managing the relationships
/// between artists, songs, and albums, as well as retrieving related entities.
class ArtistWorksManager {
  /// Maps artists to their songs.
  static final HashMap<Artist, List<Song>> _artistSongMap = HashMap();

  /// Maps artists to their albums.
  static final HashMap<Artist, List<Album>> _artistAlbumMap = HashMap();

  /// Maps songs to their artists.
  static final HashMap<Song, List<Artist>> _songArtistMap = HashMap();

  /// Maps albums to their artists.
  static final HashMap<Album, List<Artist>> _albumArtistMap = HashMap();

  /// Set of valid songs.
  static final HashSet<Song> _validSongs = HashSet();

  /// Set of valid albums.
  static final HashSet<Album> _validAlbums = HashSet();

  /// Set of valid artists.
  static final HashSet<Artist> _validArtists = HashSet();

  /// Private constructor to prevent instantiation.
  ArtistWorksManager._private();

  /// Initializes the ArtistWorksManager with the provided data.
  ///
  /// This method sets up the relationships between artists, songs, and albums.
  static Future<void> init(
      List<Album> albums,
      List<Song> songs,
      List<Artist> artists,
      HashMap<int, Album> id2Album,
      HashMap<int, Song> id2Song,
      HashMap<String, Artist> name2Artist,
      List<dynamic>? relationships,
      Map<int, String> songId2ArtistName,
      Map<Song, Album> songs2albums,
      ) async {
    // add valid instances
    _validAlbums.addAll(albums);
    _validSongs.addAll(songs);
    _validArtists.addAll(artists);

    // construct relationships
    HashSet<Album> added = HashSet();
    for (Song song in songs) {
      Artist artist = name2Artist[songId2ArtistName[song.getId()]]??
          Artist(name: 'unknown', id: 0, gender: Gender.Mysterious,
              portrait: Image.asset('assets/images/artist_portrait.jpg'),
              bio: 'this is a test bio');
      Album album = songs2albums[song]!;

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

  /// Returns a random playlist (album) from the valid albums.
  static Playlist getRandomPlaylist() {
    final randomSeed = Random().nextInt(1000000);
    final randomIndex = Random(randomSeed).nextInt(_validAlbums.length);
    return _validAlbums.elementAt(randomIndex);
  }

  /// Returns the list of artists for a given song.
  static List<Artist> getArtistsOfSong(Song song) {
    if (!_songArtistMap.containsKey(song)) {
      return [
        Artist(
          name: 'a',
          id: 000,
          gender: Gender.Mysterious,
          portrait: const Image(
            image: AssetImage('assets/images/pf.jpg'),
          ), bio: 'this is a test bio',
        )
      ];
    }
    return _songArtistMap[song]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  /// Returns a comma-separated string of artist names for a given song.
  static String getArtistsOfSongAsString(Song song) {
    return getArtistsOfSong(song)
        .map((artist) => artist.getName())
        .reduce((value, element) => '$value, $element');
  }

  /// Returns the list of artists for a given album.
  static List<Artist> getArtistsOfAlbum(Album album) {
    return _albumArtistMap[album]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  /// Returns a comma-separated string of artist names for a given album.
  static String getArtistsOfAlbumAsString(Album album) {
    return getArtistsOfAlbum(album)
        .map((artist) => artist.getName())
        .reduce((value, element) => '$value, $element');
  }

  /// Returns the list of songs for a given artist.
  static List<Song> getSongsOfArtist(Artist artist) {
    if (_artistSongMap[artist] == null) return [];
    return _artistSongMap[artist]!
      ..removeWhere((x) => !_validSongs.contains(x));
  }

  /// Returns the list of albums for a given artist.
  static List<Album> getAlbumsOfArtist(Artist artist) {
    if (_artistAlbumMap[artist] == null) return [];
    return _artistAlbumMap[artist]!
      ..removeWhere((x) => !_validAlbums.contains(x));
  }

  /// Adds a song to an artist's list of songs.
  static void addSongForArtist(Artist artist, Song song) {
    _artistSongMap.update(artist, (artist) => artist..add(song),
        ifAbsent: () => [song]);
    _songArtistMap.update(song, (song) => song..add(artist),
        ifAbsent: () => [artist]);
  }

  /// Adds an album to an artist's list of albums.
  static void addAlbumForArtist(Artist artist, Album album) {
    _artistAlbumMap.update(artist, (artist) => artist..add(album),
        ifAbsent: () => [album]);
    _albumArtistMap.update(album, (album) => album..add(artist),
        ifAbsent: () => [artist]);
  }

  /// Removes an artist from the set of valid artists.
  static void deleteArtist(Artist artist) {
    _validArtists.remove(artist);
  }

  /// Removes an album from the set of valid albums.
  static void deleteAlbum(Album album) {
    _validAlbums.remove(album);
  }

  /// Removes a song from the set of valid songs.
  static void deleteSong(Song song) {
    _validSongs.remove(song);
  }

  /// Adds an artist to the set of valid artists.
  static void addArtist(Artist artist) {
    _validArtists.add(artist);
  }

  /// Adds an album to the set of valid albums.
  static void addAlbum(Album album) {
    _validAlbums.add(album);
  }

  /// Adds a song to the set of valid songs.
  static void addSong(Song song) {
    _validSongs.add(song);
  }
}

import 'dart:collection';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class ArtistWorksManager {

  static late HashMap<Artist, List<Song>> _artistSongMap = HashMap();
  static late HashMap<Artist, List<Album>> _artistAlbumMap = HashMap();
  static late HashMap<Song, List<Artist>> _songArtistMap = HashMap();
  static late HashMap<Album, List<Artist>> _albumArtistMap = HashMap();

  static late HashSet<Song> _validSongs = HashSet();
  static late HashSet<Album> _validAlbums = HashSet();
  static late HashSet<Artist> _validArtists = HashSet();

  ArtistWorksManager._private();

  static ArtistWorksManager init(
      HashMap<Artist, List<Song>> artistSongMap,
      HashMap<Artist, List<Album>> artistAlbumMap,
      HashMap<Song, List<Artist>> songArtistMap,
      HashMap<Album, List<Artist>> albumArtistMap,
      HashSet<Song> validSongs,
      HashSet<Album> validAlbums,
      HashSet<Artist> validArtists,
      ) {

    _artistSongMap = artistSongMap;
    _artistAlbumMap = artistAlbumMap;
    _songArtistMap = songArtistMap;
    _albumArtistMap = albumArtistMap;
    _validAlbums = validAlbums;
    _validArtists = validArtists;
    _validSongs = validSongs;
    return ArtistWorksManager._private();
  }

  static List<Artist> getArtistsOfSong(Song song) {
    return _songArtistMap[song]!
      ..removeWhere((x) => !_validArtists.contains(x));
  }

  static List<Artist> getArtistsOfAlbum(Album album) {
    return _albumArtistMap[album]!
      ..removeWhere((x) => !_validArtists.contains(x));
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
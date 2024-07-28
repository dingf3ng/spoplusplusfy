import 'dart:collection';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

/// A static class for managing relationships between playlists and songs.
///
/// This class provides functionality for adding, removing, and querying songs
/// in playlists, as well as managing the validity of songs and playlists.
class PlaylistSongManager {
  /// Maps playlists to their list of songs.
  static final HashMap<Playlist, List<Song>> _listMap = HashMap();

  /// Maps songs to the list of playlists they belong to.
  static final HashMap<Song, List<Playlist>> _songMap = HashMap();

  /// Set of valid playlists.
  static final HashSet<Playlist> _validPlaylist = HashSet();

  /// Set of valid songs.
  static final HashSet<Song> _validSong = HashSet();

  /// Private constructor to prevent instantiation.
  PlaylistSongManager._privateConstructor();

  /// Initializes the PlaylistSongManager with the provided data.
  ///
  /// Parameters:
  /// - [albums]: List of [Album] objects.
  /// - [songs]: List of [Song] objects.
  /// - [id2Album]: HashMap mapping album IDs to [Album] objects.
  /// - [id2Song]: HashMap mapping song IDs to [Song] objects.
  /// - [songs2Albums]: Map associating [Song] objects with their [Album].
  static Future<void> init(
      List<Album> albums,
      List<Song> songs,
      HashMap<int, Album> id2Album,
      HashMap<int, Song> id2Song,
      Map<Song, Album> songs2Albums,
      ) async {
    _validPlaylist.addAll(albums);
    _validSong.addAll(songs);
    songs2Albums.forEach((song, album) {
      _listMap.update(album, (list) => list..add(song), ifAbsent: () => [song]);
      _songMap.update(song, (list) => list..add(album), ifAbsent: () => [album]);
    });
  }

  /// Retrieves the list of songs for a given playlist.
  ///
  /// Parameters:
  /// - [playlist]: The [Playlist] to get songs for.
  ///
  /// Returns a list of [Song] objects in the playlist.
  /// Throws an error if the playlist doesn't exist.
  static List<Song> getSongsForPlaylist(Playlist playlist) {
    if (_listMap[playlist] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    return _listMap[playlist]!
      ..removeWhere((song) => !_validSong.contains(song));
  }

  /// Adds a song to a playlist.
  ///
  /// Parameters:
  /// - [song]: The [Song] to add.
  /// - [playlist]: The [Playlist] to add the song to.
  ///
  /// Throws an error if trying to modify an immutable playlist.
  static void addSongToPlayList(Song song, Playlist playlist) {
    if (!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    _listMap.update(playlist, (list) => list..add(song),
        ifAbsent: () => [song]);
  }

  /// Deletes a song from a playlist.
  ///
  /// Parameters:
  /// - [song]: The [Song] to remove.
  /// - [playlist]: The [Playlist] to remove the song from.
  ///
  /// Throws an error if trying to modify an immutable playlist or if the playlist doesn't exist.
  static void deleteSongFromPlaylist(Song song, Playlist playlist) {
    if (!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    if (_listMap[playlist] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _listMap.update(playlist, (list) => list..remove(song));
    if (_listMap[playlist]!.isEmpty) {
      deletePlaylist(playlist);
    }
  }

  /// Deletes a playlist.
  ///
  /// Parameters:
  /// - [playlist]: The [Playlist] to delete.
  ///
  /// Throws an error if trying to delete an immutable playlist.
  static void deletePlaylist(Playlist playlist) {
    if (!playlist.isMutable()) {
      throw 'Trying to mutate a immutable playlist';
    }
    _validPlaylist.remove(playlist);
    _listMap.remove(playlist);
    //TODO: remove in database
  }

  /// Retrieves the list of playlists for a given song.
  ///
  /// Parameters:
  /// - [song]: The [Song] to get playlists for.
  ///
  /// Returns a list of [Playlist] objects containing the song.
  /// Throws an error if the song doesn't exist.
  static List<Playlist> getPlaylistsForSong(Song song) {
    if (_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    // lazy delete
    return _songMap[song]!
      ..removeWhere((playlist) => !_validPlaylist.contains(playlist));
  }

  /// Adds a playlist to a song's list of playlists.
  ///
  /// Parameters:
  /// - [song]: The [Song] to update.
  /// - [playlist]: The [Playlist] to add to the song's list.
  ///
  /// Throws an error if the song doesn't exist.
  static void addPlaylistToSong(Song song, Playlist playlist) {
    if (_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _songMap[song]!.add(playlist);
  }

  /// Removes a playlist from a song's list of playlists.
  ///
  /// Parameters:
  /// - [song]: The [Song] to update.
  /// - [playlist]: The [Playlist] to remove from the song's list.
  ///
  /// Throws an error if the song doesn't exist.
  static void deletePlaylistFromSong(Song song, Playlist playlist) {
    if (_songMap[song] == null) {
      throw 'Error by manipulating a element does not exist';
    }
    _songMap[song]!.remove(playlist);
  }

  /// Deletes a song from the manager.
  ///
  /// Parameters:
  /// - [song]: The [Song] to delete.
  static void deleteSong(Song song) {
    _validSong.remove(song);
    _songMap.remove(song);
  }

  /// Checks if a song is valid (exists in the manager).
  ///
  /// Parameters:
  /// - [song]: The [Song] to check.
  ///
  /// Returns true if the song is valid, false otherwise.
  static bool checkValidSong(Song song) {
    return _validSong.contains(song);
  }

  /// Checks if a playlist is valid (exists in the manager).
  ///
  /// Parameters:
  /// - [playlist]: The [Playlist] to check.
  ///
  /// Returns true if the playlist is valid, false otherwise.
  static bool checkValidPlaylist(Playlist playlist) {
    return _validPlaylist.contains(playlist);
  }
}
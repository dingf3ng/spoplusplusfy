import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

import '../Utilities/api_service.dart';

/// Represents an album in the music application.
///
/// This class extends [Playlist] and provides functionality specific to albums.
/// Albums are immutable by default and have a unique identifier.
class Album extends Playlist {
  /// Creates an [Album] instance.
  ///
  /// Parameters:
  /// - [name]: The name of the album.
  /// - [playlistCoverPath]: The path to the album cover image.
  /// - [id]: The unique identifier for the album.
  /// - [timeLength]: The total duration of the album (optional).
  /// - [mutable]: Whether the album can be modified (default is false).
  Album({
    required super.name,
    required super.playlistCoverPath,
    required super.id,
    super.timeLength,
    super.mutable = false,
  });

  /// Creates an [Album] instance from a map of key-value pairs.
  ///
  /// The map should contain the following keys:
  /// - 'album_id': The unique identifier for the album (int).
  /// - 'name': The name of the album (String).
  ///
  /// The album cover path is constructed using the [fhlIP] variable.
  factory Album.fromMap(Map<String, Object?> map) {
    int id = map['album_id'] as int;
    return Album(
      name: map['name'] as String,
      playlistCoverPath: 'http://$fhlIP/api/get_album_cover/${id.toString().padLeft(6, '0')}',
      id: id,
      mutable: false,
    );
  }

  /// This method is overridden but does not perform any action.
  ///
  /// It's intended to update the album with a new song, but albums are immutable.
  @override
  void updateWith(Song song) {
    return;
  }

  /// Deletes the album from the [ArtistWorksManager] and [PlaylistSongManager].
  @override
  void delete() {
    ArtistWorksManager.deleteAlbum(this);
    PlaylistSongManager.deletePlaylist(this);
  }

  /// This method is overridden but does not perform any action.
  ///
  /// It's intended to set a new name for the album, but albums are immutable.
  @override
  void setName(String newName) {
    return;
  }
}
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

/// Represents a customized playlist in the music application.
///
/// This class extends [Playlist] and provides additional functionality
/// for creating and managing user-defined playlists.
class CustomizedPlaylist extends Playlist {
  /// Creates a [CustomizedPlaylist] instance.
  ///
  /// Parameters:
  /// - [name]: The name of the playlist.
  /// - [playlistCoverPath]: The path to the playlist cover image.
  /// - [id]: The unique identifier for the playlist.
  /// - [timeLength]: The total duration of the playlist.
  /// - [mutable]: Whether the playlist can be modified (default is true).
  CustomizedPlaylist({
    required super.name,
    required super.playlistCoverPath,
    required super.id,
    required super.timeLength,
    super.mutable = true,
  });

  /// Creates a [CustomizedPlaylist] from a list of songs.
  ///
  /// This factory method creates a new customized playlist using the provided
  /// list of songs, name, and an optional cover image path.
  ///
  /// Parameters:
  /// - [song]: The list of songs to include in the playlist.
  /// - [name]: The name for the new playlist.
  /// - [useThisCover]: An optional cover image path. If not provided, it uses
  ///   the cover of the first song's playlist.
  ///
  /// Returns a new [CustomizedPlaylist] instance.
  factory CustomizedPlaylist.fromSongs(List<Song> song, String name, String? useThisCover) {
    return CustomizedPlaylist(
      name: name,
      playlistCoverPath: useThisCover ?? PlaylistSongManager.getPlaylistsForSong(song.first).first.getCoverPath(),
      id: 1,
      timeLength: song.map((song) => song.getDuration()).reduce((a, b) => a + b),
    );
  }

  /// Updates the playlist with a new song.
  ///
  /// This method overrides the base class implementation to add the song
  /// to the playlist using [PlaylistSongManager].
  ///
  /// Parameters:
  /// - [song]: The song to add to the playlist.
  @override
  void updateWith(Song song) {
    super.updateWith(song);
    PlaylistSongManager.addSongToPlayList(song, this);
  }

  /// Deletes the playlist.
  ///
  /// This method overrides the base class implementation to remove the playlist
  /// using [PlaylistSongManager].
  @override
  void delete() {
    PlaylistSongManager.deletePlaylist(this);
  }
}
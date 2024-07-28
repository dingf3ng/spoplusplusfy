import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import '../Classes/playlist.dart';

class RecommendationEngine {
 /// Creates a customized playlist from a list of existing playlists.
 ///
 /// This method aggregates songs from the provided list of playlists into a single
 /// customized playlist named 'recommendation' with a specified cover image.
 ///
 /// Parameters:
 /// - [list]: A list of [Playlist] objects from which songs will be aggregated.
 ///
 /// Returns:
 /// A [CustomizedPlaylist] object containing all the songs from the provided playlists.
 static Playlist createPlaylist(List<Playlist> list) {
  // Combine all songs from the provided playlists into a single list
  final allSongs = list
      .map((playlist) => PlaylistSongManager.getSongsForPlaylist(playlist)) // Get songs for each playlist
      .reduce((a, b) => a..addAll(b)); // Merge all song lists into one

  // Create a new customized playlist with the aggregated songs
  return CustomizedPlaylist.fromSongs(
      allSongs,
      'recommendation', // Name of the new playlist
      'assets/icons/heart_gold.svg' // Cover image for the new playlist
  );
 }
}

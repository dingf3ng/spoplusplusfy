
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';

import '../Classes/playlist.dart';

class RecommendationEngine {
 static createPlaylist(List<Playlist> list) {
  return list.map((list) => PlaylistSongManager.getSongsForPlaylist(list));
 }
}
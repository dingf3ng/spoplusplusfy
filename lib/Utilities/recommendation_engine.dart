
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';

import '../Classes/playlist.dart';


class RecommendationEngine {

 static Playlist createPlaylist(List<Playlist> list) {
  return CustomizedPlaylist.fromSongs(list
        .map((list) => PlaylistSongManager.getSongsForPlaylist(list))
        .reduce((a, b) => a..addAll(b)), 'recommendation', 'assets/icons/heart_gold.svg');
 }


}
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class CustomizedPlaylist extends Playlist {
  CustomizedPlaylist({
    required super.name,
    required super.playlistCoverPath,
    required super.id,
    required super.timeLength,
    super.mutable = true,
  });

  factory CustomizedPlaylist.fromSongs(List<Song> song, String name, String? useThisCover) {
    return CustomizedPlaylist(
        name: name,
        playlistCoverPath: useThisCover ?? PlaylistSongManager.getPlaylistsForSong(song.first).first.getCoverPath(),
        id: 1,
        timeLength: song.map((song) => song.getDuration()).reduce((a, b) => a + b),
    );
  }

  @override
  void updateWith(Song song) {
    super.updateWith(song);
    PlaylistSongManager.addSongToPlayList(song, this);
  }

  @override
  void delete() {
    PlaylistSongManager.deletePlaylist(this);
  }
}

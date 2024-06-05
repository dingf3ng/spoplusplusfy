
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class Album extends Playlist{

  Album({required super.name,
    required super.playlistCoverPath,
    required super.id,
    required super.timelength,
    super.mutable = false,
    required artist,
  });

  @override
  void updateWith(Song song) {
    return;
  }

  @override
  void delete() {
    ArtistWorksManager.deleteAlbum(this);
    PlaylistSongManager.deletePlaylist(this);
  }

  @override
  void setName(String newName) {
    return;
  }



}
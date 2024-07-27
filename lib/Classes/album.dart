import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Classes/song.dart';

import '../Utilities/api_service.dart';

class Album extends Playlist {
  Album({
    required super.name,
    required super.playlistCoverPath,
    required super.id,
    super.timeLength,
    super.mutable = false,
  });

  factory Album.fromMap(Map<String, Object?> map) {
    int id = map['album_id'] as int;
    return Album(
      name: map['name'] as String,
      playlistCoverPath: 'http://$fhlIP/api/get_album_cover/${id.toString().padLeft(6, '0')}',
      id: id,
      mutable: false,
    );
  }

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

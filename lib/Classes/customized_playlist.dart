
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

class CustomizedPlaylist extends Playlist {

  CustomizedPlaylist({
    required super.name,
    required super.playlistCoverPath,
    required super.id,
    required super.timelength,
    super.mutable = true,
  });

  @override
  void UpdateWith(Song song) {
    // TODO: implement UpdateWith
  }

  @override
  void delete() {
    // TODO: implement delete
  }

  @override
  void setName(String newName) {
    // TODO: implement setName
  }

}
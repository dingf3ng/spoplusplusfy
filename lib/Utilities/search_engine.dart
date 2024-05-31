
import 'dart:collection';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';

import '../Classes/Name.dart';
enum SearchType {artist, album, playlist, song}
class SearchEngine {

  // TODO : temp database begin
  static Set<Artist> _artistSet = {};
  static Set<Album> _albumSet = {};
  static Set<CustomizedPlaylist> _playlistSet = {};
  static Set<Song> _songSet = {};
  //TODO : temp database end

  static late HashSet<String> _tokens;

  SearchEngine._private();

  static SearchEngine init(Set<Artist> artists,
      Set<Album> albums,
      Set<CustomizedPlaylist> playlists,
      Set<Song> songs,
      HashSet<String> tokens) {
    _artistSet = artists;
    _albumSet = albums;
    _playlistSet = playlists;
    _songSet = songs;
    _tokens = tokens;
    return SearchEngine._private();
  }

  static List<String> _tokenize(String s) {
    //deal with spaces and signs
    Set<String> spsi = {' ', ',', '.', '/', '!', '?', '%', '\'', '"'};
    String pattern = spsi.map((char) => RegExp.escape(char)).join();
    RegExp regExp = RegExp('[$pattern]+');
    List<String> words = s.split(regExp);
    words = words.where((word) => word.isNotEmpty).toList();
    // remove useless words
    Set<String> ulwd = {'a','of','the','an','in','at','on','o','u'};
    words = words..removeWhere((word) => ulwd.contains(word));
    //TODO: further tokenize
    return words;
  }
  static List<Name> search(String target, SearchType arg) {
    List<Name> result = [];
    HashMap<Name, int> map = HashMap();

    Set<Name> targetSet = arg == SearchType.artist ?
    _artistSet : arg == SearchType.album ?
    _artistSet : arg == SearchType.playlist ?
    _playlistSet : _songSet;

    List<String> tokens = _tokenize(target);
    for(Name name in targetSet) {
      String temp = name.getName().toLowerCase();
      for(String s in tokens) {
        String slc = s.toLowerCase();
        if(temp.contains(slc)) {
          if(!map.containsKey(name)) result.add(name);
          map.update(name, (n) => n + 1, ifAbsent: () => 1);
        }
      }
    }

    result.sort((a, b) => map[b]! - map[a]!);
    return result;
  }
}
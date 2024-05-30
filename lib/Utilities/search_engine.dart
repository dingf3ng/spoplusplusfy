
import 'dart:collection';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/album.dart';

class SearchEngine {
  // TODO : temp database begin
  static Set<Album> _albumSet = {};
  //TODO : temp database end
  static late HashSet<String> _tokens;

  SearchEngine._private();

  static SearchEngine init(Set<Album> as, HashSet<String> tokens) {
    _albumSet = as;
    _tokens = tokens;
    return SearchEngine._private();
  }

  static List<String> tokenize(String s) {
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
  static List<Album> search(String target) {
    List<Album> result = [];
    HashMap<Album, int> map = HashMap();
    List<String> tokens = tokenize(target);
    for(Album al in _albumSet) {
      String temp = al.getName().toLowerCase();
      for(String s in tokens) {
        String slc = s.toLowerCase();
        if(temp.contains(slc)) {
          if(!map.containsKey(al)) result.add(al);
          map.update(al, (n) => n + 1, ifAbsent: () => 1);
        }
      }
    }
    result.sort((a, b) => map[b]! - map[a]!);
    return result;
  }
}
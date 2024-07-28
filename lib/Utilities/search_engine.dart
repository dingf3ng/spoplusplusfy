import 'dart:collection';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/album.dart';
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import '../Classes/name.dart';

enum SearchType { artist, album, playlist, song }

class SearchEngine {
  // Temporary in-memory database
  static Set<Artist> _artistSet = {};
  static Set<Album> _albumSet = {};
  static Set<CustomizedPlaylist> _playlistSet = {};
  static Set<Song> _songSet = {};

  // Token set for search optimization (can be used for indexing)
  static late HashSet<String> _tokens;

  // Private constructor to prevent instantiation
  SearchEngine._private();

  /// Initializes the search engine with the provided data sets and tokens.
  ///
  /// Parameters:
  /// - [artists]: A set of [Artist] objects.
  /// - [albums]: A set of [Album] objects.
  /// - [playlists]: A set of [CustomizedPlaylist] objects.
  /// - [songs]: A set of [Song] objects.
  /// - [tokens]: A set of tokens for search optimization.
  static void init(
      Set<Artist> artists,
      Set<Album> albums,
      Set<CustomizedPlaylist> playlists,
      Set<Song> songs,
      HashSet<String> tokens) {
    _artistSet = artists;
    _albumSet = albums;
    _playlistSet = playlists;
    _songSet = songs;
    _tokens = tokens;
  }

  /// Tokenizes the input string by splitting it into words and removing unnecessary characters and words.
  ///
  /// Parameters:
  /// - [s]: The input string to be tokenized.
  ///
  /// Returns:
  /// A list of tokens derived from the input string.
  static List<String> _tokenize(String s) {
    // Define characters to be treated as delimiters
    Set<String> spsi = {' ', ',', '.', '/', '!', '?', '%', '\'', '"'};
    String pattern = spsi.map((char) => RegExp.escape(char)).join();
    RegExp regExp = RegExp('[$pattern]+');

    // Split the input string by the delimiters
    List<String> words = s.split(regExp);
    words = words.where((word) => word.isNotEmpty).toList();

    // Remove common, unimportant words
    Set<String> ulwd = {'a', 'of', 'the', 'an', 'in', 'at', 'on', 'o', 'u'};
    words = words..removeWhere((word) => ulwd.contains(word));

    // Further tokenization can be added here if needed
    return words;
  }

  /// Searches for items of type [T] based on the provided target string and search type.
  ///
  /// Parameters:
  /// - [target]: The search query string.
  /// - [arg]: The type of search (artist, album, playlist, or song).
  ///
  /// Returns:
  /// A list of items of type [T] that match the search query, sorted by relevance.
  static List<T> search<T extends Name>(String target, SearchType arg) {
    List<T> result = [];
    HashMap<T, int> map = HashMap();

    // Determine the target set based on the search type
    Set<T> targetSet = (arg == SearchType.artist
        ? _artistSet
        : arg == SearchType.album
        ? _albumSet
        : arg == SearchType.playlist
        ? _playlistSet
        : _songSet)
        .cast<T>();

    // Tokenize the search query
    List<String> tokens = _tokenize(target);

    // Search through the target set
    for (T withName in targetSet) {
      String temp = withName.getName().toLowerCase();
      for (String s in tokens) {
        String slc = s.toLowerCase();
        if (temp.contains(slc)) {
          if (!map.containsKey(withName)) result.add(withName);
          map.update(withName, (n) => n + 1, ifAbsent: () => 1);
        }
      }
    }

    // Sort results based on the number of token matches
    result.sort((a, b) => map[b]! - map[a]!);
    return result;
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';

import 'Classes/album.dart';
import 'Utilities/search_engine.dart';

void main() {
  runApp(const Spoplusplusfy());
  Set<Artist> artset = { 
    Artist(name: 'Prince', id: 1, gender: Gender.Male, portrait: Image(image: )), 
  }
  Set<Album> albset = {
    Album(name: 'Sign O\' The Time', playlistCoverPath: '', id: 1, timelength: 1),
    Album(name: 'Purple Rain',  playlistCoverPath: '', id: 2, timelength: 1),
    Album(name: 'In the Aeroplane Over the Sea', playlistCoverPath: '', id: 2, timelength: 1),
    Album(name: 'Songs in the Key of Life', playlistCoverPath: '', id: 2, timelength: 1),
    Album(name: 'Ctrl', playlistCoverPath: '', id: 2, timelength: 1),
  };
  SearchEngine searchEngine = SearchEngine.init(s, HashSet());
  SearchEngine.search('Sign o the time').map((al) => al.getName()).forEach(print);
}

class Spoplusplusfy extends StatelessWidget {
  const Spoplusplusfy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.black, secondary: Color(0xffFFE8A3)),
        fontFamily: 'NotoSans',
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xffFFE8A3),
        )
      ),
      home: const SearchPage(),
    );
  }
}

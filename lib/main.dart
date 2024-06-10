import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Classes/playlist_song_manager.dart';
import 'package:spoplusplusfy/Pages/main_page.dart';

import 'Classes/album.dart';
import 'Classes/song.dart';
import 'Utilities/search_engine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ArtistWorksManager.init();
  PlaylistSongManager.init();
  runApp(const Spoplusplusfy());
}

void init() {

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
      home: MainPage(),
    );
  }
}



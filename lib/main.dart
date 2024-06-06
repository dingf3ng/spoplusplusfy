import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/main_page.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';

import 'Classes/album.dart';
import 'Classes/song.dart';
import 'Utilities/search_engine.dart';

void main() {
  final Artist prc = Artist(name: 'Prince', id: 1, gender: Gender.Male, portrait: const Image(image: AssetImage('assets/images/prince.jpg')));
  final Artist pfd = Artist(name: 'Pink Floyd', id: 2, gender: Gender.Male, portrait: const Image(image: AssetImage('assets/images/pf.jpg')));
  final Album sot = Album(name: 'Sign O\' The Time', playlistCoverPath: 'assets/images/sign.webp', id: 1, timelength: 1);
  final Album ppr = Album(name: 'Purple Rain',  playlistCoverPath: 'assets/images/purple_rain.webp', id: 2, timelength: 1);
  final Song prs = Song(name: 'Purple Rain', id: 750, duration: 1000, volume: 100, artist: prc, playlist: ppr, isMutable: false);
  final Song rbb = Song(name: 'Raspberry Beret', id: 751, duration: 1000, volume: 100, artist: prc, playlist: ppr, isMutable: false);
  Set<Artist> artset = { 
    prc,pfd
  };
  Set<Album> albset = {
    sot,ppr
  };
  Set<Song> sonset = {
    prs,rbb
  };
  ArtistWorksManager.addSongForArtist(prc, prs);
  ArtistWorksManager.addSongForArtist(prc, rbb);
  ArtistWorksManager.addAlbumForArtist(prc, sot);
  ArtistWorksManager.addAlbumForArtist(prc, ppr);
  ArtistWorksManager.addArtist(prc);
  ArtistWorksManager.addArtist(pfd);
  ArtistWorksManager.addSong(prs);
  ArtistWorksManager.addSong(rbb);
  SearchEngine searchEngine = SearchEngine.init(artset, albset, {}, sonset, HashSet());
  runApp(const Spoplusplusfy());
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

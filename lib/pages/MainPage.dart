import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';
import 'package:spoplusplusfy/main.dart';

final Color goldColour = Color.fromRGBO(255, 232, 163, 1.0);
List<SvgPicture> picList = [];

class MainPage extends StatelessWidget {
  List<Future<Playlist>> playlists = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 6; i++) {
      playlists.add(DatabaseHelper().getRandomPlaylist());
    }
    for (Future<Playlist> playlist: playlists) {
      playlist.
    }
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,),
          body:
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Text('Welcome,\nHere Are The Music For\nYou', style: TextStyle(fontSize: 40, color: goldColour, fontFamily: 'Poppins'),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 50,
                    ),
                  itemBuilder: (context, index) =>
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SearchPage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: goldColour,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image(image: AssetImage('assets/images/playlist_cover.png')),
                        ),
                      ),
                      Text('')
                    ],
                  ),
                  itemCount: picList.length),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
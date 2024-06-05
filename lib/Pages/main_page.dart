import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';
import 'package:spoplusplusfy/Classes/playlist_iterator.dart';
import 'package:spoplusplusfy/Pages/search_page.dart';
import 'package:spoplusplusfy/main.dart';
import 'package:spoplusplusfy/Pages/player_page.dart';

final Color goldColour = Color.fromRGBO(255, 232, 163, 1.0);

class MainPage extends StatelessWidget {

  Future<List<Playlist>> _getPlaylists() async {
    List<Playlist> playlists = [];
    for (int i = 0; i < 10; i++) {
      playlists.add(await DatabaseHelper().getRandomPlaylist());
    }
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder<List<Playlist>>(
          future: _getPlaylists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Playlists Available'));
            } else {
              List<Playlist> playlists = snapshot.data!;
              return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: goldColour,
                            width: 3,
                          ),
                          color: goldColour,
                          borderRadius: BorderRadius.circular(30),
                          ),
                        child: Text("enter search page", style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontFamily: 'Noto-Sans',
                        ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                   Padding(
                     padding: const EdgeInsets.only(top: 30.0),
                     child: Text(
                        '    Welcome,\n    Here Are The Music For\n    You',
                        style: TextStyle(
                          fontSize: 30,
                          color: goldColour,
                          fontFamily: 'Noto-Sans',
                        ),
                      ),
                   ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 40,
                        childAspectRatio: 0.80,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerPage(playlist: playlists[index]),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 125,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: goldColour,
                                  width: 3,
                                ),
                                color: goldColour,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/playlist_cover.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                playlists[index].getName(),
                                style: TextStyle(
                                  color: goldColour,
                                  fontFamily: 'Noto-Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemCount: playlists.length,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

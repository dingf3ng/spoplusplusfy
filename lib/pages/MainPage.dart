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
                physics: BouncingScrollPhysics(),
                children: [
                    Text(
                      '  Welcome,\n  Here Are The Music For\n  You',
                      style: TextStyle(
                        fontSize: 30,
                        color: goldColour,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                      ),
                      itemBuilder: (context, index) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: goldColour,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Image(
                                image: AssetImage('assets/images/playlist_cover.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Text(
                              playlists[index].getName(),
                              style: TextStyle(
                                color: goldColour,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ), // Display playlist name
                        ],
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

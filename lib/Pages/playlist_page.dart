import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/playlist.dart';

import '../Classes/album.dart';
import '../Classes/song.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  final List<Song> songs;

  const PlaylistPage({super.key, required this.playlist, required this.songs});

  @override
  State<StatefulWidget> createState() => PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          _playlistInfo(),
          const SizedBox(
            height: 50,
          ),
          _songsList(),
          const SizedBox(
            height: 50,
          ),
          _recommendationList(),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leadingWidth: 80,
      toolbarHeight: 70,
      leading: GestureDetector(
        onTap: () {},
        child: FittedBox(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
              child: SvgPicture.asset('assets/icons/heart_gold.svg'),
            )),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: FittedBox(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
                  child: SvgPicture.asset(
                    'assets/icons/download_gold.svg',
                    height: 32,
                    width: 32,
                  ))),
        ),
        GestureDetector(
          onTap: () {},
          child: FittedBox(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
                  child: SvgPicture.asset(
                    'assets/icons/dot_gold.svg',
                    height: 32,
                    width: 32,
                  ))),
        ),
        Container(
          width: 20,
        ),
      ],
    );
  }

  Row _playlistInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(
          width: 25,
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(
                color: secondaryColor,
                width: 3,
              ),
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(widget.playlist.getCoverPath()),
                fit: BoxFit.cover,
              )),
        ),
        const SizedBox(
          width: 25,
        ),
        SizedBox(
          width: 200,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    widget.playlist.getName(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  ArtistWorksManager.getArtistsOfAlbumAsString(
                      widget.playlist as Album),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.songs.length} songs',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                    child: VerticalDivider(
                      color: Color(0xffFFE8A3),
                      thickness: 2,
                    ),
                  ),
                  Text(
                    '${widget.songs.map((song) => song.getDuration()).reduce((a, b) => a + b) ~/ 60} min',
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          width: 25,
        ),
      ],
    );
  }

  ListView _songsList() {
    return ListView.separated(
        shrinkWrap: true,
        primary: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: 25, right: 25),
        itemBuilder: (context, index) => Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: secondaryColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 230,
                        child: Text(
                          widget.songs[index].getName(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          ArtistWorksManager.getArtistsOfSongAsString(
                              widget.songs[index]),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      _formatTime(widget.songs[index].getDuration()),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 5,
              width: 5,
            ),
        itemCount: widget.songs.length);
  }

  Visibility _recommendationList() {
    Artist priArtist =
        ArtistWorksManager.getArtistsOfAlbum(widget.playlist as Album)[0];
    List<Album> rec = ArtistWorksManager.getAlbumsOfArtist(priArtist);
    return Visibility(
      visible: rec.isNotEmpty,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: SizedBox(
                  width: 350,
                  child: Text(
                    'More by ${priArtist.getName()}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              ),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: rec.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          border: Border.all(
                            color: secondaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(rec[index].getCoverPath()),
                          )),
                    ),
                    Container(
                      width: 140,
                      alignment: Alignment.center,
                      child: Text(
                        rec[index].getName(),
                        style: const TextStyle(
                          color: secondaryColor,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTime(int duration) {
  int h = duration ~/ 3600;
  int m = (duration - h * 3600) ~/ 60;
  String s = (duration - h * 3600 - m * 60).toString().padLeft(2, '0');
  return h != 0 ? '$h:$m:0$s' : '$m:$s';
}

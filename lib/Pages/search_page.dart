
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/artist_works_manager.dart';
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Pages/main_page.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';

import '../Classes/album.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
  
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  final TextEditingController _searchController = TextEditingController();
  
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  static List<Artist> _resultArtists = [];
  static List<Album> _resultAlbums = [];
  List<CustomizedPlaylist> _resultPlaylists = [];
  List<Song> _resultSongs = [];


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchDone);
  }

  void _searchDone() {
    String query = _searchController.text;
    setState(() {
      _resultArtists =
      SearchEngine.search<Artist>(query, SearchType.artist).cast();
      _resultAlbums =
      SearchEngine.search<Album>(query, SearchType.album);
      _resultPlaylists =
      SearchEngine.search<CustomizedPlaylist>(query, SearchType.playlist);
      _resultSongs =
      SearchEngine.search(query, SearchType.song);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: primaryColor,
        appBar: _appBar(),
        body: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollUpdateNotification) {
              final ScrollMetrics metrics = notification.metrics;
              // Check if we're at the bottom of the list and the user is scrolling up
              if (metrics.pixels == metrics.maxScrollExtent && notification.scrollDelta! > 0) {
                Navigator.pop(context);
                return true;
              }
            }
            return false;
          },
          child: ListView(
            children: [
              _searchField(),
              const SizedBox(height: 40),
              _artist_showcase(),
              _album_showcase(),
              _playlist_showcase(),
              _song_showcase(),
              const SizedBox(height: 40),
            ],
          ),
        )
    );
  }

  Visibility _artist_showcase() {
    return Visibility(
      visible: _resultArtists.isNotEmpty,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Artists',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 25,),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: _resultArtists.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        border: Border.all(color: secondaryColor, width: 3),
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: ClipOval(
                        child: _resultArtists[index].getPortrait(),
                      ),
                    ),
                    Container(
                      width: 90,
                      alignment: Alignment.center,
                      child: Text(
                        _resultArtists[index].getName(),
                        style: const TextStyle(
                          color: secondaryColor,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _album_showcase() {
    return Visibility(
      visible: _resultAlbums.isNotEmpty,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Albums',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 25,),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: _resultAlbums.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                          width: 3,
                        ),
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(_resultAlbums[index].getCoverPath()),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 140,
                      child: Text(
                        _resultAlbums[index].getName(),
                        style: const TextStyle(
                          color: secondaryColor,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _playlist_showcase() {
    return Visibility(
      visible: _resultPlaylists.isNotEmpty,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Playlists',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 25,),
              padding: const EdgeInsets.only(left: 25, right: 25),
              itemCount: _resultPlaylists.length,
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
                          image: AssetImage(_resultPlaylists[index].getCoverPath()),
                        )
                      ),
                    ),
                    Container(
                      width: 140,
                      alignment: Alignment.center,
                      child: Text(
                        _resultPlaylists[index].getName(),
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Visibility _song_showcase() {
    return Visibility(
      visible: _resultSongs.isNotEmpty,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Songs',
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Container(
            height: 20,
          ),
          SizedBox(
            height: 300,
            child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(left: 25, right: 25),
              separatorBuilder: (context, index) => const SizedBox(height: 10,),
              itemCount: _resultSongs.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: secondaryColor, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          _resultSongs[index].getName(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          ArtistWorksManager
                              .getArtistsOfSongAsString(_resultSongs[index]),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          _formatTime(_resultSongs[index].getDuration()),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 90,
      backgroundColor: primaryColor,
      leading: GestureDetector(
        onTap: () {},
        child: FittedBox(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
              child: SvgPicture.asset('assets/icons/setting_gold.svg'),
            )
        ),
      ),
      actions: [
        GestureDetector(
          onTap: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'UserName ',
                style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: secondaryColor,
                ),
              ),
              SvgPicture.asset('assets/icons/share_gold.svg',height: 32, width: 32)
            ],
          ),
        ),
        Container(
          width: 20,
        ),

      ],
    );
  }

  Container _searchField() {
    return Container(

        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: secondaryColor),
          decoration: InputDecoration(
            filled: false,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    color: secondaryColor,
                    width: 2
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    color: secondaryColor,
                    width: 2
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    color: secondaryColor,
                    width: 2
                )
            ),

            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Color(0xffffE8A3), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/search_gold.svg'),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Color(0xffFFE8A3),
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 12, 12, 12),
                      child: SvgPicture.asset('assets/icons/filter_search_gold.svg'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

}

String _formatTime(int duration) {
  int h = duration ~/ 3600;
  int m = (duration - h * 3600) ~/ 60;
  int s = (duration - h * 3600 - m * 60);
  return h != 0 ? '$h:$m:$s' : '$m:$s';
}

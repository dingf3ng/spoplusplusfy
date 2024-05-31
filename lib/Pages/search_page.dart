
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/artist.dart';
import 'package:spoplusplusfy/Classes/customized_playlist.dart';
import 'package:spoplusplusfy/Classes/song.dart';
import 'package:spoplusplusfy/Utilities/search_engine.dart';

import '../Classes/album.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  //A fake database for now, to be deleted later


  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
  
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();
  
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  List<Artist> _resultArtists = [];
  List<Album> _resultAlbums = [];
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
      SearchEngine.search(query, SearchType.artist) as List<Artist>;
      _resultAlbums =
      SearchEngine.search(query, SearchType.album) as List<Album>;
      _resultPlaylists =
      SearchEngine.search(query, SearchType.playlist)
      as List<CustomizedPlaylist>;
      _resultSongs =
      SearchEngine.search(query, SearchType.song) as List<Song>;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: primaryColor,
        appBar: _appBar(),
        body: ListView(
          children: [
            _searchField(),
            const SizedBox(height: 40),
            _artist_showcase(),
            const SizedBox(height: 40),
            _album_showcase(),
            const SizedBox(height: 40),
            _playlist_showcase(),
            const SizedBox(height: 40),
            _song_showcase(),
            const SizedBox(height: 40),
          ],
        ));
  }

  Column _artist_showcase() {
    return Column(
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
        Container(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 25,),
            padding: const EdgeInsets.only(left: 25, right: 25),
            itemCount: 3,// TODO:
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(70),
                    ),
                  ),
                  const Text( // TODO: const to be deleted after adding actual name
                    'Artist', // TODO
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Column _album_showcase() {
    return Column(
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
        Container(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 25,),
            padding: const EdgeInsets.only(left: 25, right: 25),
            itemCount: 3,// TODO:
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Text( // TODO: const to be deleted after adding actual name
                    'Album', // TODO
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Column _playlist_showcase() {
    return Column(
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
        Container(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 25,),
            padding: const EdgeInsets.only(left: 25, right: 25),
            itemCount: 3,// TODO:
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Text( // TODO: const to be deleted after adding actual name
                    'Playlist', // TODO
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Column _song_showcase() {
    return Column(
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
        Container(
          height: 300,
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.only(left: 25, right: 25),
            separatorBuilder: (context, index) => const SizedBox(height: 10,),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 90,
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
                    fontStyle: FontStyle.italic
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/video.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/social_mode_player_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Page Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: UserPage(
        user: NormalUser(
          name: 'John Doe',
          portrait: Image.asset('assets/images/pf.jpg'),
          id: 23,
          gender: Gender.Mysterious,
          age: 3,
          bio: 'this is a test bio',
        ),
        isSelf: true,
      ),
    );
  }
}

class UserPage extends StatefulWidget {
  final NormalUser user;
  final bool isSelf;

  const UserPage({super.key, required this.user, required this.isSelf});

  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  int _selectedIdx = 0;
  NormalUser get user => widget.user;

  final PageController _controller = PageController();
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  static const double minThumbnailWidth = 150.0;
  static const double aspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _infoBar(),
      body: Column(
        children: [
          _buildNavigationBar(),
          _pageView(),
          Container(
            height: MediaQuery.of(context).size.height / 10,
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () {
                // TODO: Video upload search page should pop out
              },
              style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  side: const BorderSide(color: secondaryColor, width: 5)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SvgPicture.asset('assets/icons/plus_sign_gold.svg'),
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox _pageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 423 / 700,
      child: PageView(
        controller: _controller,
        onPageChanged: (index) => {
          _selectedIdx = index,
          setState(() {}),
        },
        children: [_likedVideosGridView(), _postedVideosGridView()],
      ),
    );
  }

  Widget _likedVideosGridView() {
    Future<List<Video>> videosFuture = user.getCreatedVideos();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = (width / minThumbnailWidth).floor();
        final double itemWidth = width / crossAxisCount;
        final double itemHeight = itemWidth / aspectRatio;

        return FutureBuilder<List<Video>>(
          future: videosFuture,
          builder: (context, snapshot) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data?.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return GridTile(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                      overlayColor: WidgetStateProperty.all(secondaryColor),
                    ),
                    onPressed: () {
                      if (snapshot.hasData && snapshot.connectionState==ConnectionState.done) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SocialModePlayerPage(snapshot.data!, index),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : !snapshot.hasData || snapshot.data!.isEmpty
                          ? const Center(child: Text('No videos available'))
                          : snapshot.hasError
                          ? Center(child: Text('Error: ${snapshot.error}'))
                          : ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        child: Image.network(
                          snapshot.data![index].coverImageUrl,
                          fit: BoxFit.cover,
                          width: itemWidth,
                          height: itemHeight,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


  Widget _postedVideosGridView() {
    Future<List<Video>> videosFuture = user.getLikedVideos();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = (width / minThumbnailWidth).floor();
        final double itemWidth = width / crossAxisCount;
        final double itemHeight = itemWidth / aspectRatio;

        return FutureBuilder<List<Video>>(
          future: videosFuture,
          builder: (context, snapshot) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data?.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return GridTile(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                      overlayColor: WidgetStateProperty.all(secondaryColor),
                    ),
                    onPressed: () {
                      if (snapshot.hasData && snapshot.connectionState==ConnectionState.done) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SocialModePlayerPage(snapshot.data!, index),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : !snapshot.hasData || snapshot.data!.isEmpty
                          ? const Center(child: Text('No videos available'))
                          : snapshot.hasError
                          ? Center(child: Text('Error: ${snapshot.error}'))
                          : ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        child: Image.network(
                          snapshot.data![index].coverImageUrl,
                          fit: BoxFit.cover,
                          width: itemWidth,
                          height: itemHeight,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  NavigationBar _buildNavigationBar() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return NavigationBar(
      height: height / 50,
      selectedIndex: _selectedIdx,
      backgroundColor: primaryColor,
      destinations: [
        NavigationDestination(
            selectedIcon: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: secondaryColor,
                  minimumSize: Size(width * 2 / 7, 20)),
              onPressed: () {
                _selectedIdx = 0;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Liked',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  width: 2.0,
                  color: secondaryColor,
                ),
                minimumSize: Size(width * 2 / 7, 20),
              ),
              onPressed: () {
                _selectedIdx = 0;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Liked',
                style: TextStyle(
                    color: secondaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            label: ''),
        NavigationDestination(
            selectedIcon: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: secondaryColor,
                  minimumSize: Size(width * 2 / 7, 20)),
              onPressed: () {
                _selectedIdx = 1;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Creations',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 2.0, color: secondaryColor),
                  minimumSize: Size(width * 2 / 7, 20)),
              onPressed: () {
                _selectedIdx = 1;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text('Creations',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  )),
            ),
            label: '')
      ],
    );
  }

  AppBar _infoBar() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AppBar(
      toolbarHeight: height / 4,
      backgroundColor: primaryColor,
      leading: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          Container(
            height: width / 3,
            width: width / 3,
            alignment: Alignment.center,
            child: Container(
              width: width / 3,
              height: width / 3,
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border.all(color: secondaryColor, width: 3),
                borderRadius: BorderRadius.circular(width / 3),
              ),
              child: ClipOval(
                child: widget.user.getPortrait(),
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      leadingWidth: width / 2,
      actions: [
        SizedBox(
          width: width / 2,
          height: width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.user.getName(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: widget.isSelf
                            ? MaterialStateProperty.all(primaryColor)
                            : MaterialStateProperty.all(secondaryColor),
                      ),
                      onPressed: () => {},
                      child: widget.isSelf
                          ? SvgPicture.asset(
                          'assets/icons/edit_profile_gold.svg')
                          : const Text('Follow')),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Flexible(
                child: Text(
                  user.bio,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 25,
        ),
      ],
    );
  }
}
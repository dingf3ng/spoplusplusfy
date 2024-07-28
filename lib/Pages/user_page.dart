import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';
import 'package:spoplusplusfy/Classes/video.dart';
import 'package:spoplusplusfy/Classes/person.dart';
import 'package:spoplusplusfy/Pages/social_mode_player_page.dart';
import 'package:spoplusplusfy/Pages/video_upload_page.dart';

import '../Classes/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializeFrontendData();
  runApp(MyApp());
}

/// Main entry point of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Page Demo',
      navigatorKey: navigatorKey,
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Represents the user profile page.
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

  static const double minThumbnailWidth = 150.0;
  static const double aspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return Scaffold(
      appBar: _infoBar(),
      backgroundColor: primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            SizedBox(height: 10,),
            _buildNavigationBar(),
            _pageView(),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              color: primaryColor,
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder:
                          (context) => VideoUploadPage(pageController: PageController(), user: widget.user)));
                },
                style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: secondaryColor, width: 5)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/icons/plus_sign_gold.svg',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the PageView widget that displays liked and posted videos.
  Container _pageView() {
    var primaryColor = Theme.of(context).primaryColor;
    return Container(
      color: primaryColor,
      height: MediaQuery.of(context).size.height * 415 / 700,
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

  /// Builds the GridView for liked videos.
  Widget _likedVideosGridView() {
    Future<List<Video>> videosFuture = user.getLikedVideos();
    return _gridViewForVideos(videosFuture);
  }

  /// Builds the GridView for posted videos.
  Widget _postedVideosGridView() {
    Future<List<Video>> videosFuture = user.getCreatedVideos();
    return _gridViewForVideos(videosFuture);
  }

  /// Builds the GridView for videos.
  LayoutBuilder _gridViewForVideos(Future<List<Video>> videosFuture) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = (width / minThumbnailWidth).floor();
        final double itemWidth = width / crossAxisCount;
        final double itemHeight = itemWidth / aspectRatio * 1.9;

        return FutureBuilder<List<Video>>(
          future: videosFuture,
          builder: (context, snapshot) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data?.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: itemWidth/itemHeight,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GridTile(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      overlayColor: MaterialStateProperty.all(secondaryColor),
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
                    child: _singleGrid(snapshot, context, index, itemWidth, itemHeight),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Builds a single grid item.
  GridTile _singleGrid(AsyncSnapshot<List<Video>> snapshot, BuildContext context, int index, double itemWidth, double itemHeight) {
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
    return GridTile(
      child: GestureDetector(
        onTap: () {
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
          height: itemHeight,
          width: itemWidth,
          decoration: BoxDecoration(
            border: Border.all(
              width: 3.0,
              color: secondaryColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(60)),
          ),
          child: snapshot.connectionState == ConnectionState.waiting
              ? SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.black
              ),
            ),
          )
              : !snapshot.hasData || snapshot.data!.isEmpty
              ? const Center(child: Text('No videos available'))
              : snapshot.hasError
              ? Center(child: Text('Error: ${snapshot.error}'))
              : ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
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
  }

  /// Builds the navigation bar for switching between liked and posted videos.
  Container _buildNavigationBar() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;

    return Container(
      height: height / 50,
      color: primaryColor,
      child: NavigationBar(
        backgroundColor: primaryColor,
        selectedIndex: _selectedIdx,
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
              child: Text(
                'Liked',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2.0, color: secondaryColor),
                minimumSize: Size(width * 2 / 7, 20),
              ),
              onPressed: () {
                _selectedIdx = 0;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: Text(
                'Liked',
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            label: '',
          ),
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
              child: Text(
                'Creations',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: primaryColor),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: secondaryColor),
                  minimumSize: Size(width * 2 / 7, 20)),
              onPressed: () {
                _selectedIdx = 1;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: Text(
                'Creations',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: secondaryColor),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  /// Builds the app bar with user information.
  AppBar _infoBar() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryColor = Theme.of(context).hintColor;
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
                      style: TextStyle(
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
                        'assets/icons/edit_profile_gold.svg',
                        colorFilter: ColorFilter.mode(
                            secondaryColor, BlendMode.srcIn),
                      )
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

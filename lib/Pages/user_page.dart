import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';

class UserPage extends StatefulWidget {
  final NormalUser user;
  final bool isSelf;

  const UserPage({super.key, required this.user, required this.isSelf});

  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  int _selectedIdx = 0;
  final PageController _controller = PageController();

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
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: secondaryColor, width: 5)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/icons/plus_sign_gold.svg',
                    colorFilter:
                        ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

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
        children: [_workPage(), _postPage()],
      ),
    );
  }

  ListView _workPage() {
    return ListView(
      children: const [],
    );
  }

  ListView _postPage() {
    return ListView(
      children: [
        Container(
          color: Colors.blue,
          height: 500,
        ),
        Container(
          color: Colors.green,
          height: 250,
        ),
      ],
    );
  }

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
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, color: primaryColor),
                ),
              ),
              icon: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
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
                child: Text(
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
                child: Text(
                  'Creations',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: primaryColor),
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
                child: Text('Creations',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                    )),
              ),
              label: '')
        ],
      ),
    );
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            ? WidgetStateProperty.all(primaryColor)
                            : WidgetStateProperty.all(secondaryColor),
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
                  'Some random introduction to the singer/band',
                  textAlign: TextAlign.left,
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

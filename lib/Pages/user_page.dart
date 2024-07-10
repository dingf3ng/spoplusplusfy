import 'package:flutter/material.dart';
import 'package:spoplusplusfy/Classes/normal_user.dart';

class UserPage extends StatefulWidget{
  final NormalUser user;
  final bool isSelf;
  const UserPage({super.key, required this.user, required this.isSelf});

  @override
  State<StatefulWidget> createState() => UserPageState();
  
}

class UserPageState extends State<UserPage> {
  int _selectedIdx = 0;

  final PageController _controller = PageController();
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  NavigationBar _buildNavigationBar() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return NavigationBar(
      height: height / 50,
      selectedIndex: _selectedIdx,
      destinations: [
        NavigationDestination(
            selectedIcon: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: secondaryColor),
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
                side: const BorderSide(width: 2.0, color: secondaryColor),
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
                    color: secondaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            label: ''),
        NavigationDestination(
            selectedIcon: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () {
                _selectedIdx = 1;
                _controller.animateToPage(_selectedIdx,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut);
                setState(() {});
              },
              child: const Text(
                'Creations',
                style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              ),
            ),
            icon: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2.0, color: secondaryColor),
              ),
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
          SizedBox(width: 25,),
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
          SizedBox(width: 25,),
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
                        backgroundColor:
                        WidgetStateProperty.all(secondaryColor),
                      ),
                      onPressed: () => {},
                      child: const Text('Follow')),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Flexible(
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
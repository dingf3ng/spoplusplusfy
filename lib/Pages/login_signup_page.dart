import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newton_particles/newton_particles.dart';

const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
// Define the regex pattern for username validation
const String usernamePattern = r'^[a-zA-Z0-9_-]{3,32}$';

// Define the regex pattern for password validation
const String passwordPattern = r'^.{8,32}$';

//TODO: temp verification code
const String temp_code = '123456';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  int _selectedIdx = 0;
  int _finishedCnt = 0;
  int _progressTo = 1;
  bool _buttonPressed = false;
  bool _goodEmail = false;
  bool _goodUsername = false;
  bool _goodPassword = false;
  bool _goodConfirm = false;
  bool _goodCode = false;
  bool _goodBio = false;
  bool _addedPage2 = false;
  bool _addedPage3 = false;
  String _usernamePrompt = 'What should we call you?';
  String _passwordPrompt = 'Password should be 8-16 digits long';
  String _passwordConfirmPrompt = 'Please enter again your password';
  String _emailPrompt = 'Please enter your email';
  String _emailVerificationPrompt = 'Enter the verification code';
  String _buttonText = 'Send code';
  String _bioPrompt = 'Introduce yourself here!';
  late NavigationBar _navigationBar;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  List<MyNavigationDestination> _availableDestinations = [];
  final PageController _controller = PageController();
  late Timer _emailTimer;
  int _countdownDuration = 60;
  static const Color primaryColor = Color(0x00000000);
  static const Color secondaryColor = Color(0xffFFE8A3);
  static const Color effectColor = Color.fromRGBO(0xff, 0xe8, 0xa3, 0.6);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_testEmail);
    _verificationController.addListener(_testVerification);
    _usernameController.addListener(_testUsername);
    _passwordController.addListener(_testPassword);
    _passwordConfirmController.addListener(_testPasswordConfirm);
    _bioController.addListener(_testBio);
  }


  void _testEmail() {
    String query = _emailController.text;
    setState(() {
      bool suc = RegExp(emailPattern).hasMatch(query);
      if (suc) {
        _emailPrompt = '';
      } else {
        _emailPrompt = 'Please enter a valid address';
      }
      _goodEmail = suc;
    });
  }

  void _testVerification() {
    String query = _verificationController.text;
    setState(() {
      bool suc = query == '123456';
      if (suc) {
        _emailVerificationPrompt = '';
      } else {
        _emailVerificationPrompt = 'Verification code is invalid';
      }
      _goodCode = suc;
    });
  }

  void _testUsername() {
    String query = _usernameController.text;
    setState(() {
      bool suc = RegExp(usernamePattern).hasMatch(query);
      if (suc) {
        _usernamePrompt = '';
      } else if (query.length < 4) {
        _usernamePrompt = 'Username too short';
      } else if (query.length > 32) {
        _usernamePrompt = 'Username too long';
      } else {
        _usernamePrompt =
            'Username should only contains letters, numbers, \'-\' or \'_\'';
      }
      _goodUsername = suc;
    });
  }

  void _testPassword() {
    String query = _passwordController.text;
    setState(() {
      bool suc = RegExp(passwordPattern).hasMatch(query);
      if (suc) {
        _passwordPrompt = '';
      } else if (query.length < 8 && query.isNotEmpty)
        _passwordPrompt = 'Password too short';
      else if (query.isNotEmpty) _passwordPrompt = 'Password too long';
      _goodPassword = suc;
    });
  }

  void _testPasswordConfirm() {
    String check = _passwordController.text;
    String query = _passwordConfirmController.text;
    setState(() {
      bool suc = check == query;
      if (suc) {
        _passwordConfirmPrompt = '';
      } else {
        _passwordConfirmPrompt = 'Password not same';
      }
      _goodConfirm = suc;
    });
  }

  void _testBio() {
    String query = _bioController.text;
    setState(() {
      bool suc = query.length <= 100;
      if (suc) {
        _bioPrompt = '';
      } else {
        _bioPrompt = 'Maximum length is 100 characters';
      }
      _goodBio = suc;
    });
  }

  @override
  Widget build(BuildContext context) {
    _navigationBar = _buildNavigationBar();
    return PageView(
      controller: _controller,
      physics: NeverScrollableScrollPhysics(),
      children: [_emailPage(), _userPage(), _personalInfoPage()],
    );
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
      height: 50,
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
                'Works',
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
                'Posts',
                style: TextStyle(
                    color: secondaryColor,
                    fontStyle: FontStyle.italic,
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
                'Posts',
                style: TextStyle(fontWeight: FontWeight.w600),
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
              child: const Text('Works',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  )),
            ),
            label: '')
      ],
    );
  }

  Column _typingField(String fieldName, bool test, String hintText,
      TextEditingController? controller, String iconPath) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(fieldName,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  )),
            ),
          ],
        ),
        Container(
            height: 50,
            margin: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            child: TextField(
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: controller,
              style: const TextStyle(
                  color: secondaryColor, decorationThickness: 0),
              decoration: InputDecoration(
                filled: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2)),
                contentPadding: const EdgeInsets.all(15),
                labelText: hintText,
                labelStyle:
                    const TextStyle(color: Color(0xffffE8A3), fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(iconPath),
                ),
                suffixIcon: test
                    ? SizedBox(
                        width: 50,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(6, 12, 12, 12),
                                child: SvgPicture.asset(
                                    'assets/icons/checkmark_gold.svg'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            )),
      ],
    );
  }

  Column _multilineField(String fieldName, bool test, String hintText,
      TextEditingController? controller, String iconPath) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(fieldName,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  )),
            ),
          ],
        ),
        Container(
            height: 200,
            margin: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: controller,
              style: const TextStyle(
                  color: secondaryColor, decorationThickness: 0),
              decoration: InputDecoration(
                filled: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2)),
                contentPadding: const EdgeInsets.all(15),
                labelText: hintText,
                labelStyle:
                    const TextStyle(color: Color(0xffffE8A3), fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(iconPath),
                ),
                suffixIcon: test
                    ? SizedBox(
                        width: 50,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(6, 12, 12, 12),
                                child: SvgPicture.asset(
                                    'assets/icons/checkmark_gold.svg'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            )),
      ],
    );
  }

  Scaffold _userPage() {
    return Scaffold(
      body: Stack(
        children: [
          Newton(activeEffects: [
            RainEffect(
              particleConfiguration: ParticleConfiguration(
                shape: CircleShape(),
                size: const Size(5, 5),
                color: const SingleParticleColor(color: effectColor),
              ),
              effectConfiguration: const EffectConfiguration(),
            )
          ],),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              _navigationBar,
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              _typingField('Username', _goodUsername, _usernamePrompt,
                  _usernameController, 'assets/icons/user_gold.svg'),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              _typingField('Password', _goodPassword, _passwordPrompt,
                  _passwordController, 'assets/icons/key_gold.svg'),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Visibility(
                visible: _goodPassword,
                child: _typingField(
                    'Confirm Password',
                    _goodConfirm,
                    _passwordConfirmPrompt,
                    _passwordConfirmController,
                    'assets/icons/key_gold.svg'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Visibility(
                  visible: _goodPassword && _goodConfirm && _goodUsername,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(65, 65),
                          padding: EdgeInsets.all(10),
                          side: const BorderSide(width: 2.0, color: secondaryColor),
                        ),
                        child:
                            SvgPicture.asset('assets/icons/right_arrow_gold.svg'),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Scaffold _emailPage() {
    return Scaffold(
      body: Stack(
        children: [
          Newton(activeEffects: [
            RainEffect(
              particleConfiguration: ParticleConfiguration(
                shape: CircleShape(),
                size: const Size(5, 5),
                color: const SingleParticleColor(color: effectColor),
              ),
              effectConfiguration: const EffectConfiguration(),
            )
          ],),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              _navigationBar,
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Flexible(
                      child: Text(
                    'Welcome to Spo++fy',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 55,
                        fontStyle: FontStyle.italic),
                  )),
                  SizedBox(
                    width: 25,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 325,
                    child: _typingField('Email', _goodEmail, _emailPrompt,
                        _emailController, 'assets/icons/email_gold.svg'),
                  ),
                  TextButton(
                    onPressed: () {
                      _emailTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                        setState(() {
                          _buttonText = '$_countdownDuration s';
                          _countdownDuration--;
                          _buttonPressed = true;
                        });
                        if (_countdownDuration < 0) {
                          _countdownDuration = 60;
                          _buttonText = 'Send code';
                          timer.cancel();
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: secondaryColor,
                        minimumSize: const Size(85, 50)),
                    child: Text(
                      _buttonText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Visibility(
                visible: _buttonPressed,
                child: _typingField(
                    'Verification Code',
                    _goodCode,
                    _emailVerificationPrompt,
                    _verificationController,
                    'assets/icons/verify_gold.svg'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Visibility(
                  visible: _goodEmail && _goodCode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _controller.nextPage(duration: Duration(microseconds: 600), curve: Curves.ease);
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(65, 65),
                          padding: EdgeInsets.all(10),
                          side: const BorderSide(width: 2.0, color: secondaryColor),
                        ),
                        child:
                        SvgPicture.asset('assets/icons/right_arrow_gold.svg'),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Scaffold _personalInfoPage() {
    return Scaffold(
      body: Stack(
        children: [
          Newton(activeEffects: [
            RainEffect(
              particleConfiguration: ParticleConfiguration(
                shape: CircleShape(),
                size: const Size(5, 5),
                color: const SingleParticleColor(color: effectColor),
              ),
              effectConfiguration: const EffectConfiguration(),
            )
          ],),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              _navigationBar,
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              _multilineField('Bio', _goodBio, _bioPrompt, _bioController,
                  'assets/icons/people_gold.svg'),
            ],
          ),
        ],
      ),
    );
  }
}

class MyNavigationDestination extends NavigationDestination {
  final bool selected;
  final bool finished;

  const MyNavigationDestination(
      {super.key,
      required super.icon,
      required super.label,
      required this.selected,
      required this.finished});

  MyNavigationDestination select() {
    return MyNavigationDestination(
        icon: icon, label: label, selected: true, finished: finished);
  }

  MyNavigationDestination unselect() {
    return MyNavigationDestination(
        icon: icon, label: label, selected: false, finished: finished);
  }

  MyNavigationDestination finish() {
    return MyNavigationDestination(
        icon: icon, label: label, selected: selected, finished: true);
  }

  MyNavigationDestination unfinish() {
    return MyNavigationDestination(
        icon: icon, label: label, selected: selected, finished: false);
  }
}

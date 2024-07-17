import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoplusplusfy/Classes/database.dart';
import 'package:spoplusplusfy/Pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializeFrontendData();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeNotifier(),
    child: const Spoplusplusfy(),
  ),);
}

const Color black = Colors.black;
const Color white = Colors.white70;
const Color gold = Color(0xffFFE8A3);
const Color blue = Color(0xff478CCF);
const Color purple = Color(0xff433D8B);
const Color cyan = Color(0xff36C2CE);
const Color green = Color(0xff9CDBA6);
const Color pink = Color(0xffFFB5DA);
const Color deepCyan = Color(0xff344955);
const Color red = Color(0xffFA7070);
const List<Color> secondaryColorList = [
  gold,
  blue,
  purple,
  cyan,
  green,
  pink,
  deepCyan,
  red
];

class Spoplusplusfy extends StatelessWidget {
  const Spoplusplusfy({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeNotifier tn = Provider.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: tn._currentTheme,
      home: const IntegratedMainPage(),
    );
  }

  void changeSecondaryColor() {}
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  ThemeData _currentTheme;

  ThemeNotifier() : _currentTheme = buildTheme(true, 0);

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _currentTheme;

  static ThemeData buildTheme(bool isDark, int id) {
    return isDark
        ? ThemeData(primaryColor: black, hintColor: secondaryColorList[id], canvasColor: secondaryColorList[id].withOpacity(0.6),)
        : ThemeData(primaryColor: white, hintColor: secondaryColorList[id], canvasColor: secondaryColorList[id].withOpacity(0.6));
  }

  void changeTheme(bool isDark, int id) {
    _isDarkMode = isDark;
    _currentTheme = buildTheme(isDark, id);
    notifyListeners();
  }
}

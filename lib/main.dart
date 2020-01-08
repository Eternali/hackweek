import 'package:flutter/cupertino.dart';
import 'package:hackweek/screens/home_screen.dart';

void main() => runApp(HackWeek());

class HackWeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Potluck',
      theme: CupertinoThemeData(
        primaryColor: Color(0xFF7AC5B1),
        primaryContrastingColor: Color(0xFF86A0B7),
        barBackgroundColor: Color(0xFFC58C89),
        scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
      ),
      home: HomeScreen(title: 'Potluck'),
    );
  }
}

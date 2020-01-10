import 'package:flutter/cupertino.dart';
import 'package:hackweek/screens/create_screen.dart';
import 'package:hackweek/screens/events_screen.dart';

void main() => runApp(HackWeek());

class HackWeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Spawn',
      theme: CupertinoThemeData(
        primaryColor: Color(0xFFC9D600),
        primaryContrastingColor: Color(0xFF121E28),
        barBackgroundColor: Color(0xFF121E28),
        scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
      ),
      routes: {
        '/': (context) => CreateScreen(title: 'Spawn'),
        '/events': (context) => EventsScreen(title: 'Spawn'),
      },
    );
  }
}

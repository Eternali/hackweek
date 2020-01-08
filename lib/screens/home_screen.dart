import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/food.dart';
import 'package:hackweek/features/timeline/timeline.dart';
import 'package:hackweek/data/custom_icons.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/icons/logo_no_text.svg'),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Timeline(foods: [
                    Food(
                      name: 'chicken breast',
                      expiry: DateTime.now().add(Duration(days: 3)),
                      image: 'chicken_breast.jpg',
                    ),
                    Food(
                      name: 'soy milk',
                      expiry: DateTime.now().add(Duration(days: 8)),
                      image: 'soy_milk.jpg',
                    ),
                    Food(
                      name: 'spinach',
                      expiry: DateTime.now().add(Duration(days: 4)),
                      image: 'spinach.jpeg',
                    ),
                  ]),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment(0, 0.92),
            child: Container(
              width: 70,
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: Icon(
                CupertinoIcons.add,
                color: theme.scaffoldBackgroundColor,
                size: 40,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.4, 0.96),
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.primaryContrastingColor,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(
                CupertinoIcons.person,
                color: theme.scaffoldBackgroundColor,
                size: 32,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.4, 0.96),
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.barBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Container(
                // For some reason the custom icon has whitespace on the bottom.
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  CustomIcons.receipt,
                  color: theme.scaffoldBackgroundColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

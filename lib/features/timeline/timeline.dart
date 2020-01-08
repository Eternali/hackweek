import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/food.dart';
import 'food_card.dart';

class Timeline extends StatefulWidget {
  Timeline({Key key, this.foods = const []}) : super(key: key);

  final List<Food> foods;

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Container(
      child: ListView.builder(
        itemBuilder: (context, i) {
          final dt = DateTime(now.year, now.month, now.day)
            .add(Duration(days: i));
          final todayFoods = widget.foods.where((f) {
            final diff = f.expiry.difference(dt).inHours;
            return 0 <= diff && diff < 24;
          });
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 3,
                  right: 10,
                  bottom: 5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: todayFoods.length > 0
                    ? todayFoods.map((f) => FoodCard(f)).toList()
                    : [Container(height: 75)],
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 24,
                child: Container(
                  width: 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(i == 0 ? 1 : 0),
                      topRight: Radius.circular(i == 0 ? 1 : 0),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 5,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.scaffoldBackgroundColor,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        dt.day.toString(),
                        style: TextStyle(
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
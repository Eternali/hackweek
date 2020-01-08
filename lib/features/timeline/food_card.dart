import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/food.dart';

class FoodCard extends StatelessWidget {

  const FoodCard(this.food);

  final Food food;
  
  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 250,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: Image.asset('assets/images/${food.image}'),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(food.name.toUpperCase()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/clock_utils.dart';
import 'package:hackweek/data/event.dart';

class EventCard extends StatelessWidget {
  EventCard(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.primaryContrastingColor)),
      ),
      child: Row(
        children: <Widget>[
          Text(
            event.description,
          ),
          Column(
            children: <Widget>[
              Text(
                event.isAsap ? 'ASAP' : ClockUtils.strTime(event.time),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

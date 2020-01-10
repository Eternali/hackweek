import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackweek/data/clock_utils.dart';
import 'package:hackweek/data/event.dart';
import 'package:hackweek/features/event_card/event_card.dart';
import 'package:hackweek/ui_navigator.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
                color: theme.barBackgroundColor,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: CupertinoNavigationBarBackButton(
                        color: theme.scaffoldBackgroundColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/logo_no_text.png',
                          width: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 4),
                          child: Text(
                            widget.title.toUpperCase(),
                            style: TextStyle(
                              letterSpacing: 4,
                              color: CupertinoColors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder<List<Event>>(
                    stream: Firestore.instance.collection('events').orderBy('time').snapshots()
                      .map((s) => s.documents.map((d) => Event.fromJSON(d.data)).toList()),
                    builder: (context, snapshot) {
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data?.map((e) => Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryContrastingColor,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  e.description,
                                  style: theme.textTheme.textStyle.copyWith(
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      ClockUtils.strTime(e.time),
                                      style: theme.textTheme.textStyle.copyWith(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                    Text(
                                      '< 1 km',
                                      style: theme.textTheme.textStyle.copyWith(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))?.toList() ?? [],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: UINavigator(onAdd: (context) {
                  Navigator.of(context).pushNamed('/');
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

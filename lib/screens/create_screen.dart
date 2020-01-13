import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_radio/custom_radio.dart';
import 'package:hackweek/data/event.dart';
import 'package:hackweek/ui_navigator.dart';
import 'package:hackweek/features/time_picker/time_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CreateScreen extends StatefulWidget {
  CreateScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  TextEditingController _descController;
  DateTime _time = DateTime.now().minute < 30
    ? DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute))
    : DateTime.now().add(Duration(minutes: 60 - DateTime.now().minute));
  bool _isAsap = true;
  PopSize _size = PopSize.A_FEW;
  NotiRadius _radius = NotiRadius.NEIGHBORHOOD;

  Widget popSizeBuilder(
    BuildContext context,
    List<Color> animValues,
    Function updateState,
    PopSize value,
  ) => GestureDetector(
    onTap: () {
      setState(() {
        _size = value;
      });
    },
    child: Container(
      width: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 48),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: animValues[0],
        border: Border.all(color: animValues[1], width: 2),
      ),
      child: Image.asset(
        'assets/icons/' + (value == PopSize.A_COUPLE
          ? 'a_couple' : value == PopSize.A_FEW ? 'a_few' : 'a_lot') + '.png',
        width: 30,
      ),
    ),
  );

  Widget radiusBuilder(
    BuildContext context,
    List<Color> animValues,
    Function updateState,
    NotiRadius value,
  ) => GestureDetector(
    onTap: () {
      setState(() {
        _radius = value;
      });
    },
    child: Container(
      width: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 48),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: animValues[0],
        border: Border.all(color: animValues[1], width: 2),
      ),
      child: Image.asset(
        'assets/icons/' + (value == NotiRadius.BUILDING
          ? 'building' : value == NotiRadius.NEIGHBORHOOD ? 'neighborhood' : 'city') + '.png',
        width: 30,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _descController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
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
                child: Row(
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
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: <Widget>[
                      CupertinoTextField(
                        minLines: 5,
                        maxLines: 5,
                        maxLength: 140,
                        maxLengthEnforced: true,
                        cursorColor: theme.primaryContrastingColor,
                        padding: const EdgeInsets.all(8),
                        controller: _descController,
                        placeholder: 'EVENT DESCRIPTION',
                        placeholderStyle: TextStyle(
                          color: CupertinoColors.lightBackgroundGray,
                        ),
                        enableSuggestions: true,
                        autocorrect: true,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.barBackgroundColor,
                            width: 1,
                          ),
                          color: CupertinoColors.systemGrey,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                        ),
                        style: TextStyle(
                          color: theme.barBackgroundColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: TimePicker(
                          time: _time,
                          isAsap: _isAsap,
                          onChanged: ([DateTime value]) {
                            setState(() {
                              print(value);
                              if (value != null) {
                                _time = value;
                                _isAsap = false;
                              }
                              else _isAsap = true;
                            });
                          }
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('PEOPLE'),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        CustomRadio<PopSize, Color>(
                                          value: PopSize.A_COUPLE,
                                          groupValue: _size,
                                          animsBuilder: (AnimationController controller) => [
                                            ColorTween(
                                              begin: Color(0xFFFFFFFF),
                                              end: Color(0xFF9B6A6C),
                                            ).animate(controller),
                                            ColorTween(
                                              begin: Color(0xFF9B6A6C),
                                              end: Color(0xFFFFFFFF),
                                            ).animate(controller),
                                          ],
                                          builder: popSizeBuilder,
                                        ),
                                        CustomRadio<PopSize, Color>(
                                          value: PopSize.A_FEW,
                                          groupValue: _size,
                                          animsBuilder: (AnimationController controller) => [
                                            ColorTween(
                                              begin: Color(0xFFFFFFFF),
                                              end: Color(0xFF9B6A6C),
                                            ).animate(controller),
                                            ColorTween(
                                              begin: Color(0xFF9B6A6C),
                                              end: Color(0xFFFFFFFF),
                                            ).animate(controller),
                                          ],
                                          builder: popSizeBuilder,
                                        ),
                                        CustomRadio<PopSize, Color>(
                                          value: PopSize.A_LOT,
                                          groupValue: _size,
                                          animsBuilder: (AnimationController controller) => [
                                            ColorTween(
                                              begin: Color(0xFFFFFFFF),
                                              end: Color(0xFF9B6A6C),
                                            ).animate(controller),
                                            ColorTween(
                                              begin: Color(0xFF9B6A6C),
                                              end: Color(0xFFFFFFFF),
                                            ).animate(controller),
                                          ],
                                          builder: popSizeBuilder,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 60,
                              color: CupertinoColors.systemGrey,
                            ),
                            Flexible(
                              child: Column(
                                children: <Widget>[
                                  Text('PLACE'),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        CustomRadio<NotiRadius, Color>(
                                          value: NotiRadius.BUILDING,
                                          groupValue: _radius,
                                          animsBuilder: (AnimationController controller) => [
                                            ColorTween(
                                              begin: Color(0xFFFFFFFF),
                                              end: Color(0xFF9B6A6C),
                                            ).animate(controller),
                                            ColorTween(
                                              begin: Color(0xFF9B6A6C),
                                              end: Color(0xFFFFFFFF),
                                            ).animate(controller),
                                          ],
                                          builder: radiusBuilder,
                                        ),
                                        CustomRadio<NotiRadius, Color>(
                                          value: NotiRadius.NEIGHBORHOOD,
                                          groupValue: _radius,
                                          animsBuilder: (AnimationController controller) => [
                                            ColorTween(
                                              begin: Color(0xFFFFFFFF),
                                              end: Color(0xFF9B6A6C),
                                            ).animate(controller),
                                            ColorTween(
                                              begin: Color(0xFF9B6A6C),
                                              end: Color(0xFFFFFFFF),
                                            ).animate(controller),
                                          ],
                                          builder: radiusBuilder,
                                        ),
                                        CustomRadio<NotiRadius, Color>(
                                          value: NotiRadius.CITY,
                                          groupValue: _radius,
                                          animsBuilder: (AnimationController controller) => [
                                            ColorTween(
                                              begin: Color(0xFFFFFFFF),
                                              end: Color(0xFF9B6A6C),
                                            ).animate(controller),
                                            ColorTween(
                                              begin: Color(0xFF9B6A6C),
                                              end: Color(0xFFFFFFFF),
                                            ).animate(controller),
                                          ],
                                          builder: radiusBuilder,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  Firestore.instance.collection('events').add(Event(
                    description: _descController.value.text,
                    time: _time,
                    isAsap: _isAsap,
                    size: _size,
                    radius: _radius,
                  ).toJson()).then((_) {
                    FlutterLocalNotificationsPlugin().show(id, title, body, notificationDetails)
                    Navigator.of(context).pushNamed('/events');
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

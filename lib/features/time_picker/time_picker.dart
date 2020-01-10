import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/datetime_utils.dart';
import 'package:hackweek/data/clock_utils.dart';
import 'package:vector_math/vector_math.dart';

enum CenterOption { AM, ASAP, PM }

typedef ClockCallback = dynamic Function([DateTime value]);

class TimePicker extends StatefulWidget {
  TimePicker({
    Key key,
    @required this.time,
    @required this.isAsap,
    @required this.onChanged,
  }) : super(key: key);
  final DateTime time;
  final bool isAsap;
  final ClockCallback onChanged;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  _TimePickerState() {
    _handPainterKey = GlobalKey();
  }

  GlobalKey _handPainterKey;

  FixedExtentScrollController _centerController;

  final psize = 16.0;

  /// Renderbox of the clock for the controller to work with.
  RenderBox rbox;

  /// Raw position of hour and minute hands.
  Offset hour, minute;

  bool draggingH = false, draggingM = false;

  /// Check if the drag [details] is over a clock hand.
  /// Returns [0] if not over any, [1] if over hour, [2] if over minute.
  int over(BuildContext context, DragDownDetails details) {
    final hpos = Vector3(hour.dx, hour.dy, 0);
    final fOff = (context.findRenderObject() as RenderBox).globalToLocal(details.globalPosition);
    final fpos = Vector3(fOff.dx, fOff.dy, 0);

    if(hpos.distanceTo(fpos) <= psize) return 1;
    else {
      final mpos = Vector3(minute.dx, minute.dy, 0);
      if (mpos.distanceTo(fpos) <= psize) return 2;
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rbox = _handPainterKey.currentContext.findRenderObject();
    });
    _centerController = FixedExtentScrollController(
      initialItem: widget.isAsap 
        ? CenterOption.ASAP.index : widget.time.hour <= 12
          ? CenterOption.AM.index : CenterOption.PM.index
    );
  }

  @override
  void dispose() {
    _centerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Text(
            widget.isAsap ? 'ASAP' : widget.time.isAfter(DateTime.now())
              ? ClockUtils.strTime(widget.time, DateTime.now()) : ClockUtils.strTime(widget.time),
          ),
        ),
        Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: CupertinoColors.lightBackgroundGray,
            shape: BoxShape.circle,
            border: Border.all(color: theme.barBackgroundColor, width: 1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              LayoutBuilder(
                builder: (context, constraints) {
                  if (hour == null) {
                    hour = ClockUtils.dehourifyc(widget.time.hour, Size(200, 200)); //rbox.size);
                    minute = ClockUtils.deminutifyc(widget.time.minute, Size(200, 200)); //rbox.size);
                  }
                  return GestureDetector(
                    onPanDown: (DragDownDetails details) {
                      final o = over(context, details);
                      if (o == 1) {
                        draggingH = true;
                        draggingM = false;
                      } else if (o == 2) {
                        draggingH = false;
                        draggingM = true;
                      }
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        if (draggingH) {
                          hour = ClockUtils.dehourifyc(
                            ClockUtils.hourifyc(details.localPosition, Size(200, 200)),
                            Size(200, 200),
                          );
                        } else if (draggingM) {
                          minute = ClockUtils.deminutifyc(
                            ClockUtils.minutifyc(details.localPosition, Size(200, 200)),
                            Size(200, 200),
                          );
                        }
                      });
                    },
                    onPanEnd: (DragEndDetails details) {
                      if (draggingH) {
                        draggingH = false;
                        if (_centerController.selectedItem == CenterOption.ASAP.index) _centerController.jumpToItem(0);
                        int nHour = ClockUtils.hourifyc(hour, Size(200, 200));
                        if (_centerController.selectedItem == CenterOption.PM.index) nHour += 12;
                        widget.onChanged(widget.time.copyWith(hour: nHour).add(Duration(
                          days: nHour < DateTime.now().hour ? 1 : 0,
                        )));
                      } else if (draggingM) {
                        draggingM = false;
                        final now = DateTime.now();
                        final nMinute = ClockUtils.minutifyc(minute, Size(200, 200));
                        if (_centerController.selectedItem == CenterOption.ASAP.index)
                          if (now.hour >= 12 &&
                            (now.hour < widget.time.hour || (now.hour == widget.time.hour && now.minute < nMinute)))
                            _centerController.jumpToItem(2);
                          else _centerController.jumpToItem(0);
                        widget.onChanged(widget.time.copyWith(minute: nMinute).add(Duration(
                          days: widget.time.hour < now.hour && nMinute <= now.minute ? 1 : 0,
                        )));
                      }
                    },
                    child: Container(
                      key: _handPainterKey,
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        painter: HandsPainter(
                          hour: hour,
                          minute: minute,
                          hourColor: theme.primaryContrastingColor,
                          minuteColor: theme.primaryColor,
                          psize: psize,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.barBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: CupertinoPicker(
                  itemExtent: 30,
                  backgroundColor: Color(0x00000000),
                  scrollController: _centerController,
                  onSelectedItemChanged: (value) {
                    if (value == CenterOption.ASAP.index) return widget.onChanged();
                    DateTime newTime = widget.time
                      .copyWith(hour: ClockUtils.hourifyc(hour, Size(200, 200)));
                    if (value == CenterOption.AM.index) {
                      if (newTime.isBefore(DateTime.now())) return widget.onChanged(newTime.add(Duration(days: 1)));
                      return widget.onChanged(newTime);
                    } else if (value == CenterOption.PM.index) {
                      newTime = newTime.subtract(Duration(hours: 12));
                      if (newTime.isBefore(DateTime.now()))
                        newTime = newTime.add(Duration(days: 1));
                      if (newTime.isBefore(DateTime.now()))
                        return widget.onChanged(newTime.add(Duration(days: 1)));
                      return widget.onChanged(newTime);
                    }
                  },
                  children: CenterOption.values.map((m) => Container(
                    alignment: Alignment.center,
                    child: Text(
                      m.toString().split('.').last,
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 16,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }
}

class HandsPainter extends CustomPainter {
  HandsPainter({this.hour, this.minute, this.hourColor, this.minuteColor, this.psize}) {
    _hPaint = Paint()
      ..color = hourColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..isAntiAlias = true;
    _mPaint = Paint()
      ..color = minuteColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..isAntiAlias = true;
  }

  final Offset hour, minute;
  final Color hourColor, minuteColor;
  final double psize;
  Paint _hPaint, _mPaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (int m = 0; m <= 59; m += 5) {
      final polStart = ClockUtils.deminutify(m, size).scale(1.05, 1);
      final polEnd = ClockUtils.deminutify(m, size).scale(1.15, 1);
      canvas.drawLine(
        ClockUtils.cartesianize(polStart, size),
        ClockUtils.cartesianize(polEnd, size),
        _hPaint,
      );
    }
    canvas.drawCircle(minute, psize, _mPaint);
    canvas.drawLine(Offset(size.width / 2, size.height / 2), minute, _mPaint);
    canvas.drawCircle(hour, psize, _hPaint);
    canvas.drawLine(Offset(size.width / 2, size.height / 2), hour, _hPaint);

    final pStyle = ParagraphStyle(textAlign: TextAlign.center);
    final h = ClockUtils.hourifyc(hour, size);
    final hpBuilder = ParagraphBuilder(pStyle)
      ..addText((h == 0 ? 12 : h).toString());
    final mpBuilder = ParagraphBuilder(pStyle)
      ..addText(ClockUtils.minutifyc(minute, size).toString());
    final hText = hpBuilder.build()..layout(ParagraphConstraints(width: 40));
    final mText = mpBuilder.build()..layout(ParagraphConstraints(width: 40));

    canvas.drawParagraph(hText, Offset(hour.dx - hText.width / 2, hour.dy - hText.height / 2));
    canvas.drawParagraph(mText, Offset(minute.dx - mText.width / 2, minute.dy - mText.height / 2));
  }

  @override
  bool shouldRepaint(HandsPainter oldDelegate) {
    return hour != oldDelegate.hour || minute != oldDelegate.minute
      || hourColor != oldDelegate.hourColor || minuteColor != oldDelegate.minuteColor;
  }
}

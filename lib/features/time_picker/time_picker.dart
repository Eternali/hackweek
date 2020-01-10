import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/datetime_utils.dart';
import 'package:hackweek/data/clock_utils.dart';

enum CenterOption { AM, ASAP, PM }

typedef ClockCallback = void Function(DateTime value);

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

  /// Renderbox of the clock for the controller to work with.
  RenderBox rbox;

  /// Raw position of hour and minute hands.
  Offset hour, minute;

  /// Check if the drag [details] is over a clock hand.
  bool isOver(DragDownDetails details) {
    // final pos = Vector3(pointerPos.dx, pointerPos.dy, 0);
    // final fOff = (context.findRenderObject() as RenderBox).globalToLocal(details.globalPosition);
    // final fpos = Vector3(fOff.dx, fOff.dy, 0);
    // return pos.distanceTo(fpos) <= widget.pointerSize;
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
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            widget.isAsap ? 'ASAP' : widget.time.isAfter(DateTime.now())
              ? ClockUtils.strTime(widget.time, DateTime.now()) : ClockUtils.strTime(widget.time),
          ),
        ),
        Container(
          width: 200,
          height: 200,
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
                  // hour = dehourify(widget.time.hour, rbox.size);
                  // minute = deminutify(widget.time.minute, rbox.size);
                  return GestureDetector(
                    child: Container(
                      key: _handPainterKey,
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        painter: HandsPainter(
                          hour: ClockUtils.dehourifyc(widget.time.hour, Size(200, 200)),
                          minute: ClockUtils.deminutifyc(widget.time.minute, Size(200, 200)),
                          hourColor: theme.primaryContrastingColor,
                          minuteColor: theme.primaryColor,
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
  HandsPainter({this.hour, this.minute, this.hourColor, this.minuteColor}) {
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
  Paint _hPaint, _mPaint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(minute, 12, _mPaint);
    canvas.drawLine(Offset(size.width / 2, size.height / 2), minute, _mPaint);
    canvas.drawCircle(hour, 12, _hPaint);
    canvas.drawLine(Offset(size.width / 2, size.height / 2), hour, _hPaint);
    for (int m = 0; m <= 59; m += 5) {
      final polStart = ClockUtils.deminutify(m, size);
      final polEnd = ClockUtils.deminutify(m, size).scale(1.1, 1);
      canvas.drawLine(
        ClockUtils.cartesianize(polStart, size),
        ClockUtils.cartesianize(polEnd, size),
        _hPaint,
      );
    }
  }

  @override
  bool shouldRepaint(HandsPainter oldDelegate) {
    return hour != oldDelegate.hour || minute != oldDelegate.minute
      || hourColor != oldDelegate.hourColor || minuteColor != oldDelegate.minuteColor;
  }
}

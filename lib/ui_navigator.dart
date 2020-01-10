import 'package:flutter/cupertino.dart';
import 'package:hackweek/data/custom_icons.dart';

class UINavigator extends StatefulWidget {
  UINavigator({Key key, this.opacity = 0, this.onAdd}) : super(key: key);

  final int opacity;
  final Function onAdd;

  @override
  _UINavigatorState createState() => _UINavigatorState();
}

class _UINavigatorState extends State<UINavigator> {
  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CustomPaint(
      painter: OutlinePainter(
        color: CupertinoColors.systemGrey,
        opacity: 255,
      ),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 25, right: 20),
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.primaryContrastingColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Icon(
                CupertinoIcons.person,
                color: theme.scaffoldBackgroundColor,
                size: 32,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onAdd(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Icon(
                  CupertinoIcons.add,
                  color: theme.scaffoldBackgroundColor,
                  size: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if(ModalRoute.of(context).settings.name != '/events')
                  Navigator.of(context).pushNamed('/events');
              },
              child: Container(
                margin: const EdgeInsets.only(top: 25, left: 20),
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryContrastingColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
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
      ),
    );
  }
}

class OutlinePainter extends CustomPainter {
  OutlinePainter({this.color, this.opacity}) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 5
      ..isAntiAlias = true;
  }

  final Color color;
  final int opacity;

  Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0.93 * size.width, size.height)
        ..lineTo(0.07 * size.width, size.height)
        ..quadraticBezierTo(
          0.5 * size.width, -1.1 * size.height,
          0.93 * size.width, size.height,
        ),
      _paint
    );
  }

  @override
  bool shouldRepaint(OutlinePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}

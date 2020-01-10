import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ClockUtils {
  static String strTime(DateTime time, [DateTime now]) {
    // Return time formatted like 'Jan 1, 2:30 PM'.
    if (now == null) return DateFormat.MMMd().add_jm().format(time);
    else if (now.isAfter(time)) return '';
    String str = time.day > now.day ? 'Today' : 'Tomorrow';
    return '$str at ${DateFormat.jm().format(time)}';
  }

  /// Map a [raw] position to a set of dimensions specified by [constraints].
  static Offset polarize(Offset raw, Size size) {
    final x = raw.dx - size.width / 2;
    final y = raw.dy - size.height / 2;
    return Offset(
      sqrt(pow(x, 2) + pow(y, 2)),
      atan(y / x),
    );
  }

  /// Map a regularized [pos] to an offset on the current RenderBox.
  static Offset cartesianize(Offset pol, Size size) {
    return Offset(
      cos(pol.dy) * pol.dx + size.width / 2,
      -sin(pol.dy) * pol.dx + size.width / 2,
    );
  }

  /// Map polar coordinates to hour.
  static int hourify(Offset pol, Size size) {
    int hour = 3 - (pol.dy * (6 / pi)).floor();
    if (hour < 0) hour = 12 - hour;
    return hour;
  }

  /// Map cartesian coordinates to hour.
  static int hourifyc(Offset cart, Size size) => hourify(polarize(cart, size), size);
  
  /// Map polar coordinates to minute.
  static int minutify(Offset pol, Size size) {
    int minute = 15 - (pol.dy * (30 / pi)).floor();
    if (minute < 0) minute = 60 - minute;
    return minute;
  }

  /// Map cartesian coordinates to minute.
  static int minutifyc(Offset cart, Size size) => minutify(polarize(cart, size), size);

  /// Map hour [h] to polar coordinates.
  static Offset dehourify(int h, Size size) {
    // Convert hour to radian from 0 to 2pi.
    double theta = (3 - (h % 12)).toDouble();
    if (theta < 0) theta = 12 + theta;
    theta *= (pi / 6);
    double rad = sqrt(pow(size.width * 0.2, 2) + pow(size.height * 0.2, 2));
    return Offset(rad, theta);
  }

  /// Map hour [h] to cartesian coordinates.
  static Offset dehourifyc(int h, Size size) => cartesianize(dehourify(h, size), size);

  /// Map minute [m] to polar coordinates.
  static Offset deminutify(int m, Size size) {
    // Convert minute to radian from 0 to 2pi.
    double theta = (15 - (m % 60)).toDouble();
    if (theta < 0) theta = 60 + theta;
    theta *= (pi / 30);
    double rad = sqrt(pow(size.width * 0.36, 2) + pow(size.height * 0.36, 2));
    return Offset(rad, theta);
  }

  /// Map minute [m] to cartesian coordinates.
  static Offset deminutifyc(int m, Size size) => cartesianize(deminutify(m, size), size);
}

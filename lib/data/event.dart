import 'package:cloud_firestore/cloud_firestore.dart';

enum PopSize {
  A_COUPLE,
  A_FEW,
  A_LOT,
}

enum NotiRadius {
  BUILDING,
  NEIGHBORHOOD,
  CITY,
}

class Event {
  const Event({
    this.description,
    this.time,
    this.isAsap,
    this.size,
    this.radius,
  });

  // Description of the event.
  final String description;
  
  // Time of the event (can only be set to within 24 hours of current time).
  final DateTime time;

  // Whether or not the event is ASAP, if true [time] will be ignored.
  final bool isAsap;

  // Relative desired number of participants.
  final PopSize size;

  // Relative restriction on the location of users notified.
  final NotiRadius radius;

  dynamic toJson() {
    return {
      'description': description,
      'time': Timestamp.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
      'isAsap': isAsap,
      'size': size.index,
      'radius': radius.index,
    };
  }

  static Event fromJSON(dynamic raw) {
    return Event(
      description: raw['description'],
      time: DateTime.fromMillisecondsSinceEpoch(raw['time'].millisecondsSinceEpoch),
      isAsap: raw['isAsap'],
      size: PopSize.values[raw['size']],
      radius: NotiRadius.values[raw['radius']],
    );
  }
}
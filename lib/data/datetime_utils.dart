extension Utils on DateTime {
  DateTime copyWith({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond
    );
  }
}
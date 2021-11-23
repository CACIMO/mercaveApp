import 'package:flutter/foundation.dart';

class DateService {
  static getSecondsToNow({@required DateTime dateTime}) {
    return dateTime.difference(DateTime.now()).inSeconds;
  }
}

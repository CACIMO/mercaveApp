import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StringService {
  static String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  static getPriceFormat({@required double number}) {
    final formatter = new NumberFormat("#,###");

    if (number == null) {
      return '\$ 0';
    }
    return '\$ ' + formatter.format(number).replaceAll(',', '.');
  }
}

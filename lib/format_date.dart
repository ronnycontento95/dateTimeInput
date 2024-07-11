import 'package:flutter/material.dart';

class Formater {
  static DateTime? type4(String input, TextEditingController controller) {
    int maxLength = 11;
    _typeTemplate(input, controller, '-', maxLength);
    if (input.length >= maxLength - 1) {
      return _parseDateTimeLong(input);
    }
    return null;
  }

  static DateTime _parseDateTimeLong(String input) {
    int day = int.parse(input.substring(8, 10));
    int month = int.parse(input.substring(5, 6));
    int year = int.parse(input.substring(0, 4));
    return DateTime(year, month, day);
  }

  static bool _isValidYear(String year) {
    return int.tryParse(year) != null && int.parse(year) > 1900 && int.parse(year) < 2100;
  }

  static bool _isValidMonth(String month) {
    int m = int.tryParse(month) ?? 0;
    return m > 0 && m <= 12;
  }

  static bool _isValidDay(String day) {
    int d = int.tryParse(day) ?? 0;
    return d > 0 && d <= 31;
  }

  static void _typeTemplate(
      String input, TextEditingController controller, String separator, int lastIndex) {
    switch (input.length) {
      case 1:
      case 2:
      case 3:
      case 4:
        if (input.length == 4 && !_isValidYear(input)) {
          controller.text = input.substring(0, 3);
        }
        break;
      case 5:
        controller.text = '${input.substring(0, 4)}$separator';
        break;
      case 6:
      case 7:
        if (input.length == 7) {
          String monthPart = input.substring(5).replaceAll(separator, '');
          if (!_isValidMonth(monthPart)) {
            controller.text = input.substring(0, 5);
          }
        }
        break;
      case 8:
        controller.text = '${input.substring(0, 7)}$separator';
        break;
      case 9:
      case 10:
        if (input.length == 10 && !_isValidDay(input.substring(8))) {
          controller.text = input.substring(0, 8);
        }
        break;
      default:
        if (input.length == lastIndex) {
          controller.text = input.substring(0, lastIndex - 1);
        }
    }
  }
}

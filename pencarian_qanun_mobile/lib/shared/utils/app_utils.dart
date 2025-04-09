import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';

class AppUtils {
  AppUtils._();

  static String toRoman(int number) {
    if (number < 1 || number > 3999) {
      throw ArgumentError('Number must be between 1 and 3999');
    }

    final List<MapEntry<int, String>> romanNumerals = [
      const MapEntry(1000, 'M'),
      const MapEntry(900, 'CM'),
      const MapEntry(500, 'D'),
      const MapEntry(400, 'CD'),
      const MapEntry(100, 'C'),
      const MapEntry(90, 'XC'),
      const MapEntry(50, 'L'),
      const MapEntry(40, 'XL'),
      const MapEntry(10, 'X'),
      const MapEntry(9, 'IX'),
      const MapEntry(5, 'V'),
      const MapEntry(4, 'IV'),
      const MapEntry(1, 'I'),
    ];

    String result = '';

    for (final entry in romanNumerals) {
      while (number >= entry.key) {
        result += entry.value;
        number -= entry.key;
      }
    }

    return result;
  }

  static AppBar emptyAppBar({Color? backgroundColor}) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 0,
      shadowColor: Colors.transparent,
      backgroundColor: backgroundColor ?? AppColors.background,
    );
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColors.secondary,
      textColor: Colors.black,
    );
  }
}

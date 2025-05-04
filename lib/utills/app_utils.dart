import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


import '../res/app_colors.dart';

import '../views/widgets/app_custom_text.dart';
import 'app_navigator.dart';

class AppUtils {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }




  static Size deviceScreenSize(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return queryData.size;
  }

  static String convertPrice(dynamic price, {bool showCurrency = false}) {
    double amount = price is String ? double.parse(price) : price;
    final formatCurrency = NumberFormat("#,##0.00", "en_US");
    return '${showCurrency ? 'NGN' : ''} ${formatCurrency.format(amount)}';
  }

  static DateTime timeToDateTime(TimeOfDay time, [DateTime? date]) {
    final newDate = date ?? DateTime.now();
    return DateTime(
        newDate.year, newDate.month, newDate.day, time.hour, time.minute);
  }

  static String formatComplexDate({required String dateTime}) {
    if (dateTime != '') {
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(dateTime);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('d MMM y hh:mm');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    } else {
      return '';
    }
  }

  static String formatDate({required String parsedDateTime}) {
    if (parsedDateTime != '') {
      DateTime dateTime = DateTime.parse(parsedDateTime);

      DateFormat formatter = DateFormat('MMMM d, yyyy, H:mm aa');

      String formattedDate = formatter.format(dateTime);


      return formattedDate;
    } else {
      return '';
    }
  }


  void debuglog(object) {
    if (kDebugMode) {
      print(object.toString());
      // debugPrint(object.toString());
    }
  }

  void copyToClipboard(textToCopy, context) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomText(
      text: "copied to clipboard",
      color: Colors.white,
    )));
  AppUtils().debuglog('Text copied to clipboard: $textToCopy');
  }

  static String formateSimpleDate({String? dateTime}) {
    var inputDate = DateTime.parse(dateTime!);

    var outputFormat = DateFormat('MMM d, hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }


  static final dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final dateFormat = DateFormat('dd MMM, yyyy');
  static final timeFormat = DateFormat('hh:mm a');
  static final apiDateFormat = DateFormat('yyyy-MM-dd');
  static final utcTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  static final dayOfWeekFormat = DateFormat('EEEEE', 'en_US');
}

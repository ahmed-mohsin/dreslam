import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

Widget flushBar(context, bool goodresponse, {String massage, int sec}) {
  return Flushbar(
    backgroundColor: goodresponse == true ? greenColor : flushBarnNegative,
    message: massage,
    duration: Duration(seconds: sec != null ? 2 : sec),
    icon: goodresponse == true
        ? Icon(
            Icons.thumb_up,
            color: Colors.white,
          )
        : Icon(
            Icons.sentiment_dissatisfied,
            color: Colors.white,
          ),
    margin: EdgeInsets.all(8),
    borderRadius: 8,
  )..show(context);
}

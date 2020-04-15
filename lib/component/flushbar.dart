import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../colors.dart';

Widget flushBar(context, bool goodresponse, {String massage, int sec}) {
  return Flushbar(
    backgroundColor: goodresponse == true ? greenColor : redColor,
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

Widget activationMenu(context,String user, String deviceId ) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "تفعيل حساب",
    desc: "هل تريد تفعيل حسابك علي هذا الجهاز ؟ عند موافقه الادارة لن يعمل الحساب علي اي جهاز اخر ",
    buttons: [
      DialogButton(
        child: Text(
          "ليس الآن",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: (){Navigator.pop(context);} ,
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "تفعيل",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: (){
          Firestore.instance
              .collection("AccountsActivation")
              .document(user)
              .setData({
            "userid": user,
            'deviceid':deviceId
          });
          Firestore.instance
              .collection("UsersID")
              .document(user)
              .updateData({
            "registeredPhone": "wait",
          });
          print("activation sent to admin");
          Navigator.pop(context);} ,
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}


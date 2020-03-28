import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'PlayerPage.dart';

void getdata() {}
void signInWithEmailAndPassword(
    {String email,
    String password,
    FirebaseUser user,
    BuildContext context}) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on');
  print('Running on ${androidInfo.id}');
  print('Running on ');
  print(
      'Running on ${androidInfo.brand}  ${androidInfo.model}  ${androidInfo.androidId}');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  user = (await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  ))
      .user;

  if (user != null) {
    print("login successfully hello${user.displayName}");
    // Login successfu
    // /Data/appDatal
    Firestore.instance
        .collection("Data")
        .document("appData")
        .updateData({"users": FieldValue.increment(1)});

    Firestore.instance.collection('Users').document(user.uid).setData({
      "name": user.uid,
      "mobile": 1220,
      "phone type":
          '${androidInfo.brand}${androidInfo.model}${androidInfo.androidId}',
    });

    DocumentReference ref =
        Firestore.instance.collection('Data').document("appData");
    ref.get().then((data) {
      if (data.exists) {
        String code = data.data['code'];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => YoutubePlayerPage("ivioby1mcYI")));
      }
    });
    // Navigate to main page
//
//    Navigator.pushReplacement(
//        context, MaterialPageRoute(builder: (_) => YoutubePlayerPage("")));
  } else {
    // Invalid email and password
    // Navigate to registration page
  }
}

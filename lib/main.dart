import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UserScreens/Splash.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(enableVibration: true,playSound: true,
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        )
      ]
  );
  AwesomeNotifications().firebaseAppToken.then((value) {
    print("fcm token =========================>>>>>"+value);
  } );
  WidgetsFlutterBinding.ensureInitialized();
  final appDoc = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDoc.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dr Eslam El Shahawy',
      theme: ThemeData(
        fontFamily: 'arn',
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

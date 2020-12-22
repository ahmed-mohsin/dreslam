import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UserScreens/Splash.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
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

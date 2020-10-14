import 'dart:async';

import 'package:dreslamelshahawy/AdminPanal/AdminBoard.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

import '../Decorations.dart';
import '../LoginScreen.dart';
import '../Rooms.dart';
import '../colors.dart';
import '../main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool checkHive;
  String loginTypo;
  String userName;
  String cashedUserName, cashedPassWord;

  @override
  void initState() {
    setState(() {
      checkHive = false;
    });

    void _gotoLogin() async {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      final defaults = <String, dynamic>{'welcome': 'default welcome'};
      await remoteConfig.setDefaults(defaults);

      await remoteConfig.fetch(expiration: const Duration(hours: 5));
      await remoteConfig.activateFetched();
      print('welcome message: ' + remoteConfig.getString('welcome'));

      Timer(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      });
    }

    void _gotoRooms() async {
      Timer(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Rooms()),
          (Route<dynamic> route) => false,
        );
      });
    }

    void _gotoadmins() async {
      Timer(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminBoard()),
          (Route<dynamic> route) => false,
        );
      });
    }

    final roomDataBox = Hive.openBox("roomsData");
    roomDataBox.then((data) {
      setState(() {
        loginTypo = data.get("rememberLoginType");
        userName = data.get("rememberuserName");
        cashedUserName = data.get("cashedUserController");
        cashedPassWord = data.get("cashedPasswordController");
        print(data.get("rememberLoginType"));
        print(data.get("rememberuserName"));
        print("cashed name >>>>>>>>>>>>>>>>>>> $cashedUserName");
        print("cashed password >>>>>>>>>>>>>>>>>>> $cashedPassWord");
        if (loginTypo != null && userName != null) {
          print("there is data ");

          if (loginTypo != "admin") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => LoginScreen(
                          cashedUserController: cashedUserName,
                          cashedUserPasswordController: cashedPassWord,
                        )));

          }
          if (loginTypo == "admin") {
            _gotoadmins();
          }
        } else {
          _gotoLogin();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(image: decorationImage("bg.png")),
          height: screenHeight,
          width: screenWidth,
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 33),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration:
                            BoxDecoration(image: decorationImage("logo.png")),
                      ),
                    ),
                    checkHive == false
                        ? SpinKitCircle(
                            color: redColor,
                            size: 70,
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

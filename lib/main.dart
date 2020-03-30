import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/services.dart';
import 'AdminPanal/AdminBoard.dart';
import 'Decorations.dart';
import 'Loader.dart';
import 'Rooms.dart';
import 'colors.dart';
import 'component/flushbar.dart';
import 'component/version.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDoc = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDoc.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dr Eslam Elshahawy ',
      theme: ThemeData(
        fontFamily: 'arn',
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool checkHive;
  String loginTypo;
  String userName;

  @override
  void initState() {
    setState(() {
      checkHive = false;
    });

    void _gotoLogin() async {
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
        print(data.get("rememberLoginType"));
        print(data.get("rememberuserName"));
        if (loginTypo != null && userName != null) {
          print("there is data ");

          if (loginTypo != "admin") {
            /////////////////////////////////////////////
            DocumentReference ref =
                Firestore.instance.collection('Data').document("appData");
            ref.get().then((data) {
              if (data.exists) {
                print(data.data["version"]);
                if (data.data["version"] == currentVersion) {
                  print("version is ok i wil go to room");

                  Firestore.instance
                      .collection("Data")
                      .document("appData")
                      .updateData(
                          {"usersLogedinFromShared": FieldValue.increment(1)});

                  _gotoRooms();
                } else {
                  flushBar(context, false,
                      sec: 60,
                      massage:
                          "يوجد نسخة جديدة من التطبيق رجاء قم بتحديث هذه النسخة اولا ");
                  _gotoLogin();
                }
              }
            });

            /////////////////////////////////////////////

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
                            color: greenColor,
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//  FirebaseUser user;
  String loadingPhase;
  bool rememberMe;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var userController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadingPhase = " ";
    super.initState();
//    userController = new TextEditingController(text: 'admin@admin.com');
//    passwordController = new TextEditingController(text: 'admin123456');
  }

  //print(roomNameBox.get("roomdata"));

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    rememberMe = true;
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(image: decorationImage("g3.jpg")),
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        height: 250,
                        width: 250,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextFormField(
                            enableSuggestions: true,
                            style: TextStyle(color: Colors.white),
                            controller: userController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration.collapsed(
                                hintText: "E-MaiL",
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter correct User';
                              }
                              return null;
                            },
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * .75,
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextFormField(
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            controller: passwordController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration.collapsed(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white70)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter right password';
                              }
                              return null;
                            },
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * .75,
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                onChanged: (value) {
                                  print("remember me changed to $value");
                                },
                                value: rememberMe,
                                activeColor: redColor,
                                inactiveThumbColor: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * .75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                      ),
//                    Padding(
//                      padding: const EdgeInsets.all(18.0),
//                      child: MaterialButton(
//                          height: 40,
//                          minWidth: MediaQuery.of(context).size.width * .70,
//                          color: Colors.black87,
//                          onPressed: () {
//                            signInWithEmailAndPassword(
//                                context: context,
//                                email: "user1@samehaleem.com",
//                                password: "user1112233",
//                                user: user);
//                          },
//                          child: Text(
//                            'log in',
//                            style: TextStyle(color: Colors.white, fontSize: 20),
//                          )),
//                    ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RoundedLoadingButton(
                          width: 200,
                          color: redColor,
                          controller: _btnController,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              setState(() {
                                loadingPhase = "validation error";
                                print(loadingPhase);
                              });
                              _btnController.reset();
                              return;
                            }
                            _formKey.currentState.save();

                            try {
                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidInfo =
                                  await deviceInfo.androidInfo;
                              print(
                                  'Running on ${androidInfo.brand}  ${androidInfo.model}  ${androidInfo.androidId}');
                              final FirebaseAuth _auth = FirebaseAuth.instance;
                              user = (await _auth.signInWithEmailAndPassword(
                                email: userController.text,
                                password: passwordController.text,
                              ))
                                  .user;
                              if (user != null) {
                                DocumentReference ref = Firestore.instance
                                    .collection('Data')
                                    .document("appData");
                                ref.get().then((data) {
                                  if (data.exists) {
                                    setState(() {
                                      loadingPhase =
                                          "Checking app version .....";
                                      print(loadingPhase);
                                    });
                                    //check app version
                                    print(data.data["version"]);
                                    if (data.data["version"] ==
                                        currentVersion) {
                                      Firestore.instance
                                          .collection("Data")
                                          .document("appData")
                                          .updateData({
                                        "users": FieldValue.increment(1)
                                      });

                                      final roomDataBox = Hive.box("roomsData");

                                      roomDataBox.put("LoginType",
                                          "${user.email.substring(0, 5)}");
                                      roomDataBox.put(
                                          "userName", "${user.email}");

                                      if (user.email.substring(0, 5) ==
                                          "admin") {
                                        roomDataBox.put("roomsName", []);
                                        roomDataBox.put("roomsCode", []);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminBoard()),
                                          (Route<dynamic> route) => false,
                                        );
                                        print(roomDataBox.get("LoginType"));
                                        print(roomDataBox.get("roomsName"));
                                        print(roomDataBox.get("roomsName"));

                                        if (rememberMe == true) {
                                          roomDataBox.put("rememberLoginType",
                                              "${user.email.substring(0, 5)}");
                                          roomDataBox.put("rememberuserName",
                                              "${user.email}");
                                        }
                                      }

                                      DocumentReference getUserdata = Firestore
                                          .instance
                                          .collection('UsersID')
                                          .document(user.email.substring(0, 8));
                                      getUserdata.get().then((data) {
                                        if (data == null) {
                                          flushBar(context, false,
                                              sec: 60,
                                              massage: "فشلت عملية الدخول");
                                          _btnController.reset();
                                        } else {
                                          print(
                                              "log innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
                                          roomDataBox.put("roomsName",
                                              data.data["roomsName"]);
                                          roomDataBox.put("roomsCode",
                                              data.data["roomsCode"]);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Rooms()),
                                            (Route<dynamic> route) => false,
                                          );
                                          print(roomDataBox.get("LoginType"));
                                          print(roomDataBox.get("roomsName"));
                                          print(roomDataBox.get("roomsName"));

                                          if (rememberMe == true) {
                                            roomDataBox.put("rememberLoginType",
                                                "${user.email.substring(0, 5)}");
                                            roomDataBox.put("rememberuserName",
                                                "${user.email}");
                                          }

                                          _btnController.success();
                                        }
                                      });
                                    } else {
                                      flushBar(context, false,
                                          sec: 60,
                                          massage:
                                              "يوجد نسخة جديدة من التطبيق رجاء قم بتحديث هذه النسخة اولا ");
                                      _btnController.reset();
                                    }
                                  }
                                });
                              }
                            } on PlatformException catch (e) {
                              print(e.code);
                              String errorType;
                              if (Platform.isAndroid) {
                                switch (e.code) {
                                  case "ERROR_USER_DISABLED":
                                    errorType =
                                        " هذا الحساب تم ايقافه من قبل الادارة الرجاء الاتصال بنا ";
                                    break;
                                  case "ERROR_TOO_MANY_REQUESTS":
                                    errorType =
                                        " Too  Many Request Try again later  ";
                                    break;
                                  case "ERROR_INVALID_EMAIL":
                                    errorType =
                                        "تأكد من كتابه الايميل بطريقه صحيحة";
                                    break;
                                  case 'ERROR_USER_NOT_FOUND':
                                    errorType = "اسم المستخدم او الباسورد خطأ";
                                    break;
                                  case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                                    errorType = "The User iZ Not Found";
                                    break;
                                  case 'ERROR_WRONG_PASSWORD':
                                    errorType = "اسم المستخدم او الباسورد خطأ";
                                    break;
                                  case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                                    errorType = "NetworkError";
                                    break;
                                  // ...
                                  default:
                                    errorType =
                                        "INVALID_EMAIL or Connection Error Try again Later ";
                                }
                              } else if (Platform.isIOS) {
                                switch (e.code) {
                                  case 'Error 17011':
                                    errorType = "UserNotFound";
                                    break;
                                  case 'Error 17009':
                                    errorType = "PasswordNotValid";
                                    break;
                                  case 'Error 17020':
                                    errorType = "NetworkError";
                                    break;
                                  // ...
                                  default:
                                    errorType =
                                        "Connection Error Try again Later ";
                                }
                              }
                              print('The error is $errorType');
                              _btnController.reset();
                              flushBar(context, false,
                                  massage: errorType, sec: 10);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Log In",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * .40,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      Image.asset(
                        "assets/logo2.png",
                        color: goldenColor,
                        height: 90,
                        width: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

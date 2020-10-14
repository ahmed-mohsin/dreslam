import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminPanal/AdminBoard.dart';
import 'Decorations.dart';
import 'HomePage.dart';
import 'appData.dart';
import 'colors.dart';
import 'component/flushbar.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  String cashedUserController;

  String cashedUserPasswordController;

  LoginScreen({this.cashedUserController, this.cashedUserPasswordController});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//  FirebaseUser user;
  String deviceiD;
  String studentYear;
  String loadingPhase;
  bool rememberMe;
  bool showAlertDialogbool;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btn2Controller =
      new RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var userController = TextEditingController();
  var passwordController = TextEditingController();
  var roomDataBox;

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  getshowDialogAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showAlertDialogbool = prefs.getBool("showDialogAlert");
    print("showwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww dialog =>>>>>>>>>>>>>>>>>>>>>>>.$showAlertDialogbool");
  }
  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo.androidId);
      print(androidInfo.board);
      print(androidInfo.bootloader);
      print("brand>>>>>>>>>>>>>>>>>>>>>>>." + androidInfo.brand);
      print("device>>>>>>>>>>>>>>>>>>>>>>>>" + androidInfo.device);
      print(androidInfo.display);
      print(androidInfo.fingerprint);
      print(androidInfo.hardware);
      print(androidInfo.host);
      print(androidInfo.id);
      print(androidInfo.isPhysicalDevice);
      print(androidInfo.manufacturer);
      print("model>>>>>>>>>>>>>>>>>>>>>>>" + androidInfo.model);
      print(androidInfo.product);
      print(androidInfo.type);
      print(androidInfo.version.toString());
      deviceiD = androidInfo.model + "  ## " + androidInfo.androidId;
      print('Running on $deviceiD');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(">>>>>>utsname${iosInfo.utsname}");
      print(iosInfo.model);
      print(iosInfo.identifierForVendor);
      print(iosInfo.localizedModel);
      print(iosInfo.name);
      print(iosInfo.systemName);
      print(iosInfo.systemVersion);
      print("${iosInfo.model}" + "${iosInfo.identifierForVendor}");
      deviceiD =
          "${iosInfo.model}" + "  ## " + "${iosInfo.identifierForVendor}";
    }
  }

  @override
  void initState() {
    roomDataBox = Hive.box("roomsData");
    getDeviceId();
    loadingPhase = " ";
    super.initState();
    getshowDialogAlert();
    widget.cashedUserController != null
        ? userController =
            new TextEditingController(text: widget.cashedUserController)
        : TextEditingController(text: '');
    widget.cashedUserPasswordController != null
        ? passwordController =
            new TextEditingController(text: widget.cashedUserPasswordController)
        : TextEditingController(text: '');
  }

  //print(roomNameBox.get("roomdata"));

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    rememberMe = true;
    return Container(
      child: Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(image: decorationImage("g1.jpg")),
              height: screenHeight,
              width: screenWidth,
              child: Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                image: decorationImage("logo.png")),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          child: Center(
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
                          height: 40,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: TextFormField(
                                obscureText: true,
                                style: TextStyle(color: Colors.white),
                                controller: passwordController,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.white70)),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter right password';
                                  }
                                  return null;
                                },
                              ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
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
                                final FirebaseAuth _auth =
                                    FirebaseAuth.instance;
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
                                          AndroidcurrentVersion) {
                                        Firestore.instance
                                            .collection("Data")
                                            .document("appData")
                                            .updateData({
                                          "users": FieldValue.increment(1),
                                          "usersv$AndroidcurrentVersion":
                                              FieldValue.increment(1)
                                        });

                                        roomDataBox.put("cashedUserController",
                                            "${userController.text}");
                                        roomDataBox.put(
                                            "cashedPasswordController",
                                            "${passwordController.text}");

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

                                        DocumentReference getUserdata =
                                            Firestore.instance
                                                .collection('UsersID')
                                                .document(
                                                    user.email.substring(0, 8));
                                        getUserdata.get().then((data) {
                                          if (data == null) {
                                            flushBar(context, false,
                                                sec: 60,
                                                massage: "فشلت عملية الدخول");
                                            _btnController.reset();
                                          } else {
                                            if (data.data["registeredPhone"] ==
                                                deviceiD) {
                                              print("matching device id ");
                                              print(
                                                  "show the alertdailog == ${data.data["avaliable"]}");
                                              roomDataBox.put("roomsName",
                                                  data.data["roomsName"]);
                                              roomDataBox.put("roomsCode",
                                                  data.data["roomsCode"]);
                                              ;
                                              /////////getid
                                              roomDataBox.put(
                                                  "UID", data.data["userId"]);
                                              print(
                                                  "===>>>>>>>>>>>>>${data.data["userId"]}");
                                              if (data.data["avaliable"] ==
                                                  true) {
                                                showAlertDialog(
                                                    context: context,
                                                    UID: data.data["userId"],
                                                    roomName:
                                                        data.data["roomsName"],
                                                    userId:
                                                        data.data["userId"]);
                                              } else {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              }

                                              print(
                                                  roomDataBox.get("LoginType"));
                                              print(
                                                  roomDataBox.get("roomsName"));
                                              print(
                                                  roomDataBox.get("roomsName"));

                                              if (rememberMe == true) {
                                                roomDataBox.put(
                                                    "rememberLoginType",
                                                    "${user.email.substring(0, 5)}");
                                                roomDataBox.put(
                                                    "rememberuserName",
                                                    "${user.email}");
                                              }

                                              _btnController.reset();
                                            } else if (data
                                                    .data["registeredPhone"] ==
                                                "empty") {
                                              print(
                                                  "empty the phone not regesterd yet click to register it ");
                                              print(data.data["userId"]);
                                              print(deviceiD);
                                              activationMenu(
                                                  context,
                                                  "${data.data["userId"]}",
                                                  "$deviceiD");

                                              _btnController.reset();
                                            } else if (data
                                                    .data["registeredPhone"] ==
                                                "any") {
                                              print("matching device id ");
                                              roomDataBox.put("roomsName",
                                                  data.data["roomsName"]);
                                              roomDataBox.put("roomsCode",
                                                  data.data["roomsCode"]);
                                              /////////getid
                                              roomDataBox.put(
                                                  "UID", data.data["userId"]);
                                              print(
                                                  "===>>>>>>>>>>>>>${data.data["userId"]}");
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()),
                                                (Route<dynamic> route) => false,
                                              );

                                              _btnController.reset();
                                            } else if (data
                                                    .data["registeredPhone"] ==
                                                "wait") {
                                              print("old account");
                                              flushBar(context, false,
                                                  sec: 1200,
                                                  massage:
                                                      "تم ارسال طلبك للتفعيل من قبل , انتظر تفعيله من عند الاداره");
                                              _btnController.reset();
                                            } else {
                                              print("old account");
                                              flushBar(context, false,
                                                  sec: 60,
                                                  massage:
                                                      "هذا الحساب لم يعد يعمل  الاتصال بالاداره ");
                                              _btnController.reset();
                                            }
                                          }
                                        });
                                      } else {
                                        InkWell(
                                          onTap: () {
                                            print("clicked");
                                          },
                                          child: flushBar(context, false,
                                              sec: 2000,
                                              massage:
                                                  "يوجد نسخة جديدة من التطبيق رجاء قم بتحديث هذه النسخة اولا "),
                                        );
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
                                      errorType =
                                          "اسم المستخدم او الباسورد خطأ";
                                      break;
                                    case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                                      errorType = "The User iZ Not Found";
                                      break;
                                    case 'ERROR_WRONG_PASSWORD':
                                      errorType =
                                          "اسم المستخدم او الباسورد خطأ";
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
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width * .40,
                              decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Platform.isAndroid==true?Container():Text(
                            ", Register as A New User",
                            style: TextStyle(
                                color: goldenColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Column(
                            children: [
                              RoundedLoadingButton(
                                height: 47,
                                width: 200,
                                color: goldenColor,
                                controller: _btn2Controller,
                                onPressed: () async {
                                  final FirebaseAuth _auth = FirebaseAuth.instance;
                                  user = (await _auth.signInWithEmailAndPassword(
                                    email: "iphonevisitor@admin.com",
                                    password: "iphonevisitor",
                                  ))
                                      .user;
                                  print(user.email);
                                  roomDataBox.put("roomsName", []);
                                  roomDataBox.put("roomsCode", []);
//

                                  showAlertDialogbool==false?Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (_) => HomePage())):showAlertDialogReg(context: context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .40,
                                  child: Text(
                                    "Or aVisitor",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(
      {BuildContext context,
      String userId,
      var roomName,
      var roomsCode,
      var UID}) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final _name = TextEditingController();
          final _mail = TextEditingController();
          final _mobile = TextEditingController();
          final formKey = GlobalKey<FormState>();
          bool _termsChecked = false;
          String genderType = "male";

          int radioValue = -1;
          bool _autoValidate = false;
          void _validateInputs() {
            final form = formKey.currentState;
            if (form.validate()) {
              // Text forms has validated.
              // Let's validate radios and checkbox
              if (radioValue < 0) {
                print("Please select your gender");
                // None of the radio buttons was selected
                // _showSnackBar('Please select your gender');
              } else if (!_termsChecked) {
                // The checkbox wasn't checked
                print("Please select your hghghg");
                //_showSnackBar("Please accept our terms");
              } else {
                // Every of the data in the form are valid at this point
                form.save();
              }
            } else {
              setState(() => _autoValidate = true);
            }
          }

          void validateInputs() {
            final form = formKey.currentState;
            if (form.validate()) {
              // Text forms was validated.
              form.save();
            } else {
              setState(() => _autoValidate = true);
            }
          }

          int _radioValue1 = 0;
          void _handleRadioValueChange1(int value) {
            setState(() {
              _radioValue1 = value;
            });
          }

          // set up the buttons
          Widget cancelButton = FlatButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: mainColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
          Widget continueButton = FlatButton(
            child: Text(
              "Continue",
              style: TextStyle(color: mainColor),
            ),
            onPressed: () async {
              if (!formKey.currentState.validate()) {
                return;
              } else {
                DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                if (Platform.isAndroid) {
                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                  print(androidInfo.androidId);
                  print(androidInfo.board);
                  print(androidInfo.bootloader);
                  print("brand>>>>>>>>>>>>>>>>>>>>>>>." + androidInfo.brand);
                  print("device>>>>>>>>>>>>>>>>>>>>>>>>" + androidInfo.device);
                  print(androidInfo.display);
                  print(androidInfo.fingerprint);
                  print(androidInfo.hardware);
                  print(androidInfo.host);
                  print(androidInfo.id);
                  print(androidInfo.isPhysicalDevice);
                  print(androidInfo.manufacturer);
                  print("model>>>>>>>>>>>>>>>>>>>>>>>" + androidInfo.model);
                  print(androidInfo.product);
                  print(androidInfo.type);
                  print(androidInfo.version.toString());
                  deviceiD =
                      androidInfo.model + "  ## " + androidInfo.androidId;
                  print('Running on $deviceiD');
                  print(
                      'Running on ${androidInfo.brand}  ${androidInfo.model}  ${androidInfo.androidId}');

                  Firestore.instance
                      .collection('UsersID')
                      .document(UID)
                      .updateData({
                    "avaliable": false,
                    'FormuserName': _name.text,
                    'FormuserMail': _mail.text,
                    'FormuserMobile': _mobile.text,
                    "FormuserId": userId,
                    "Form login at": FieldValue.serverTimestamp(),
                    "Form deviceId":
                        "${androidInfo.brand}=>${androidInfo.model}",
                  }).then((data) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  });
                } else if (Platform.isIOS) {
                  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                  print(">>>>>>utsname${iosInfo.utsname}");
                  print(iosInfo.model);
                  print(iosInfo.identifierForVendor);
                  print(iosInfo.localizedModel);
                  print(iosInfo.name);
                  print(iosInfo.systemName);
                  print(iosInfo.systemVersion);
                  print("${iosInfo.model}" + "${iosInfo.identifierForVendor}");
                  deviceiD = "${iosInfo.model}" +
                      "  ## " +
                      "${iosInfo.identifierForVendor}";
                  Firestore.instance
                      .collection('UsersID')
                      .document(UID)
                      .updateData({
                    "avaliable": false,
                    'FormuserName': _name.text,
                    'FormuserMail': _mail.text,
                    'FormuserMobile': _mobile.text,
                    "FormuserId": userId,
                    "Form login at": FieldValue.serverTimestamp(),
                    "Form deviceId":
                        "${iosInfo.identifierForVendor}=>${iosInfo.model}",
                  }).then((data) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  });
                }
              }
            },
          );

          return AlertDialog(
            actions: [
              cancelButton,
              continueButton,
            ],
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 400,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      alignment: Alignment.center,
                      child: Card(
                        //color: Colors.white,
                        elevation: 0,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "ادخل البيانات بدقه حتي تكتمل عملية التفعيل."),
                              Divider(),
                              Text(
                                "** لن تظهر الرسالة مرة اخري اذا كانت البيانات صحيحة",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * .7,
                                height: 85,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _name,
                                  validator: (value) {
                                    if (value.length < 7)
                                      return 'اكتب اسم صحيح';
                                    else if (value.isEmpty) {
                                      return ' *اكتب الإسم';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "الاسم",
                                      filled: true,
                                      fillColor: Colors.grey.shade50),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .7,
                                  height: 85,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _mail,
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'اكتب ايميل صحيح';
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "الايميل الشخصي",
                                        filled: true,
                                        fillColor: Colors.grey.shade50),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .7,
                                height: 85,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _mobile,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return ' *اكتب الموبايل';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "الموبايل",
                                      filled: true,
                                      fillColor: Colors.grey.shade50),
                                ),
                              ),
                              /*Column(
                                children: <Widget>[
                                  new RadioListTile<int>(
                                      title: new Text('حقوق عربي'),
                                      value: 0,
                                      groupValue: radioValue,
                                      onChanged: _handleRadioValueChange1),
                                  new RadioListTile<int>(
                                      title: new Text('حقوق انجليزي'),
                                      value: 1,
                                      groupValue: radioValue,
                                      onChanged: _handleRadioValueChange1),
                                ],
                              ),*/
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        new Radio(
//                          value: 0,
//                          groupValue: _radioValue1,
//                          onChanged: _handleRadioValueChange1,
//                        ),
//                        new Text(
//                          'Carnivore',
//                          style: new TextStyle(fontSize: 16.0),
//                        ),
//                        new Radio(
//                          value: 1,
//                          groupValue: _radioValue1,
//                          onChanged: _handleRadioValueChange1,
//                        ),
//                        new Text(
//                          'Herbivore',
//                          style: new TextStyle(
//                            fontSize: 16.0,
//                          ),
//                        ),
//                      ],
//                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  showAlertDialogReg(
      {BuildContext context,
      String userId,
      var roomName,
      var roomsCode,
      var UID}) {
    bool loading = false;
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final _name = TextEditingController();
          final _mail = TextEditingController();
          final _mobile = TextEditingController();
          final formKey = GlobalKey<FormState>();
          bool _termsChecked = false;
          String genderType = "male";

          int radioValue = -1;
          bool _autoValidate = false;
          void _validateInputs() {
            final form = formKey.currentState;
            if (form.validate()) {
              // Text forms has validated.
              // Let's validate radios and checkbox
              if (radioValue < 0) {
                print("Please select your gender");
                // None of the radio buttons was selected
                // _showSnackBar('Please select your gender');
              } else if (!_termsChecked) {
                // The checkbox wasn't checked
                print("Please select your hghghg");
                //_showSnackBar("Please accept our terms");
              } else {
                // Every of the data in the form are valid at this point
                form.save();
              }
            } else {
              setState(() => _autoValidate = true);
            }
          }

          void validateInputs() {
            final form = formKey.currentState;
            if (form.validate()) {
              // Text forms was validated.
              form.save();
            } else {
              setState(() => _autoValidate = true);
            }
          }

          int _radioValue1 = 0;
          void _handleRadioValueChange1(int value) {
            setState(() {
              _radioValue1 = value;
            });
          }

          // set up the buttons
          Widget cancelButton = FlatButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: mainColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              _btn2Controller.reset();            },
          );
          Widget continueButton = FlatButton(
            child: Text(
              "Continue",
              style: TextStyle(color: mainColor),
            ),
            onPressed: () async {
              if (!formKey.currentState.validate()) {
                return;
              } else {
                setState(() {
                  loading = true;
                });
                Firestore.instance
                    .collection(studentYear)
                    .document(_mobile.text)
                    .setData({
                  'FormuserName': _name.text,
                  'FormuserMail': _mail.text,
                  'FormuserMobile': _mobile.text,
                  "studentYear": studentYear,
                }).then((data)async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
                  );
                  SharedPreferences myPrefs = await SharedPreferences.getInstance();
                  myPrefs.setBool('showDialogAlert', false);
                });

                _btn2Controller.success();
              }
            },
          );

          String _dropDownValue;
          return AlertDialog(
            actions: [
              cancelButton,
              loading == false
                  ? continueButton
                  : Container(
                      color: Colors.red,
                      height: 50,
                      width: 50,
                    ),
            ],
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 400,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      alignment: Alignment.center,
                      child: Card(
                        //color: Colors.white,
                        elevation: 0,
                        child: Form(
                          autovalidate: _autoValidate,
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("من فضلك ادخل هذه البيانات"),
                                Container(
                                  width: MediaQuery.of(context).size.width * .7,
                                  height: 85,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _name,
                                    validator: (value) {
                                      if (value.length < 7)
                                        return 'اكتب اسم صحيح';
                                      else if (value.isEmpty) {
                                        return ' *اكتب الإسم';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "الاسم",
                                        filled: true,
                                        fillColor: Colors.grey.shade50),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    height: 85,
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _mail,
                                      validator: (value) {
                                        Pattern pattern =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                        RegExp regex = new RegExp(pattern);
                                        if (!regex.hasMatch(value))
                                          return 'اكتب ايميل صحيح';
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: "الايميل الشخصي",
                                          filled: true,
                                          fillColor: Colors.grey.shade50),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .7,
                                  height: 85,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _mobile,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return ' *اكتب الموبايل';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "الموبايل",
                                        filled: true,
                                        fillColor: Colors.grey.shade50),
                                  ),
                                ),
                                DropdownButton(
                                  hint: _dropDownValue == null
                                      ? Text(
                                          'اختر الفرقة الدراسية',
                                          style: TextStyle(color: redColor),
                                        )
                                      : Text(
                                          _dropDownValue,
                                          style: TextStyle(color: mainColor),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  style: TextStyle(color: mainColor),
                                  items: [
                                    'الأولي',
                                    'الثانية',
                                    'الثالثة',
                                    "الرابعة"
                                  ].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(
                                          val,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: greyblackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    setState(
                                      () {
                                        _dropDownValue = val;
                                        studentYear = val;
                                        print(studentYear);
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

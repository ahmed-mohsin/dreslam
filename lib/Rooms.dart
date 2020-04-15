
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:dreslamelshahawy/player2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:line_icons/line_icons.dart';
import 'Decorations.dart';
import 'HandleConnectionerror.dart';
import 'Loader.dart';
import 'LoginScreen.dart';
import 'PlayerPage.dart';
import 'RoomsContent/RoomContentVideos.dart';
import 'RoomsContent/RoomsContentBooks.dart';
import 'RoomsContent/StudentAsk.dart';
import 'colors.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  final roomDataBox = Hive.openBox("roomsData");

  List roomsName = [];

  @override
  void initState() {
    roomDataBox.then((data) {
      setState(() {
        roomsName = data.get("roomsName");
      });
    });
  }

  Future<bool> alert() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          "الخروج من التطبيق",
          style: TextStyle( fontFamily: 'arn',color: mainColor),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: new Text("هل تود تسجيل الخروج من التطبيق ؟",
              style: TextStyle(
                  color: Colors.grey,
                  //fontWeight: FontWeight.bold,
                  fontFamily: 'arn')),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "إلغاء ",
              style: TextStyle(fontFamily: 'arn',color: mainColor),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            isDefaultAction: false,
            child: new Text(
              "خروج",
              style: TextStyle(fontFamily: 'arn',color: Colors.grey),
            ),
            onPressed: () async {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              roomDataBox.then((data) {
                data.clear();
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );

            },
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(

          appBar: AppBar(
            actions: <Widget>[IconButton(icon: Icon(LineIcons.sign_out,color: mainColor,), onPressed: (){
              alert();
            })],
            iconTheme: new IconThemeData(color: greenColor),
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              "المواد",
              style: TextStyle(color: mainColor),
            ),
        ),
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,

          body: roomsName.length == 0
              ? SignInToSeeContent()
              : Container(
                  decoration: BoxDecoration(image: decorationImage("g3.jpg")),
                  width: screenWidth,
                  height: screenHeight,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Roomslist(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class SignInToSeeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: decorationImage("g3.jpg")),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
        "Sign in with activated Student account  \n  you must have at least one activated Material to see this section",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: MaterialButton(color: goldenColor,child: Text("login",style: TextStyle(color: Colors.white),),onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                }),
              )
            ],
          )),
    );
  }
}

class Roomslist extends StatefulWidget {
  @override
  _RoomslistState createState() => _RoomslistState();
}

class _RoomslistState extends State<Roomslist> {
  List roomsName = [];
  List roomsCode = [];
  String userName;
  String UID;
  bool saved;

  @override
  void initState() {
    final roomDataBox = Hive.openBox("roomsData");

    roomDataBox.then((data) {
      setState(() {
        roomsName = data.get("roomsName");
        userName = data.get("userName");
        roomsCode = data.get("roomsCode");
        UID = data.get("UID");
      });
      print(data.get("userName"));
      print(UID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(UID);
    final userinfoDataBox = Hive.openBox("userData");
    userinfoDataBox.then((data) {
      saved = data.get("saved");
      print(saved);
    });
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: roomsName.length,
      itemBuilder: (_, index) {
        if (roomsName.length == 0) {
          return Text("لا توجد مواد الآن");
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomContent(roomsName[index].toString(),
                          roomsCode[index].toString()),
                    ));

//                if (saved == null) {
//                  showAlertDialog(context, userName,
//                      roomsName[index].toString(), roomsCode[index].toString());
//                } else {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (_) => RoomContent(roomsName[index].toString(),
//                            roomsCode[index].toString()),
//                      ));
//                }

//                DocumentReference getRoomVideoCode = Firestore.instance
//                    .collection('AdminPanal.Rooms')
//                    .document(roomsCode[index].toString());
//                getRoomVideoCode.get().then((data) {
//                  if (data.data["code"] == null) {
//                    flushBar(context, false,
//                        sec: 60, massage: " لا يوجد محتوي لهذه المادة الآن");
//                  } else {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (_) =>
//                                YoutubePlayerPage(data.data["code"])));
//                  }
//                });
              },
              child: Container(
                child: new Container(
                  decoration: BoxDecoration(
                    border: Border.all(color:mainColor),
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: mainColor,
                                ),
                              ),
                              Text(
                                roomsName[index].toString(),
                                style:
                                    TextStyle(color: mainColor, fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        /*Padding(
                          padding:
                          const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            snapshot.data.documents[index]['name'],
                            style: TextStyle(color: Colors.white30),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  showAlertDialog(
      BuildContext context, String userId, var roomName, var roomsCode) {
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
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          );
          Widget continueButton = FlatButton(
            child: Text("Continue"),
            onPressed: () async {
              if (!formKey.currentState.validate()) {
                return;
              } else {
                DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                print(
                    'Running on ${androidInfo.brand}  ${androidInfo.model}  ${androidInfo.androidId}');

                Firestore.instance
                    .collection('UsersID')
                    .document(UID)
                    .updateData({
                  "Formgender": genderType,
                  'FormuserName': _name.text,
                  'FormuserMail': _mail.text,
                  'FormuserMobile': _mobile.text,
                  "FormuserId": userId,
                  "Form login at": FieldValue.serverTimestamp(),
                  "Form deviceId": "${androidInfo.brand}=>${androidInfo.model}",
                }).then((data) {
                  final userBox = Hive.box("userData");
                  setState(() {
                    userBox.put("saved", true);
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoomContent(roomName, roomsCode),
                      ));
                });
              }
            },
          );

          int selectedRadioClass = 0;
          int selectedRadiogender = 0;

          return AlertDialog(
            actions: [
              cancelButton,
              continueButton,
            ],
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 350,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("ادخل البيانات حتي تتمكن من مشاهدة المادة"),
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Radio<int>(
                                        activeColor: greenColor,
                                        value: 0,
                                        groupValue: selectedRadiogender,
                                        onChanged: (int value) {
                                          setState(() {
                                            selectedRadiogender = value;
                                            print("male");
                                            genderType = "ذكر";
                                          });
                                        },
                                      ),
                                      Text("ذكر"),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Radio<int>(
                                        activeColor: greenColor,
                                        value: 1,
                                        groupValue: selectedRadiogender,
                                        onChanged: (int value) {
                                          setState(() {
                                            selectedRadiogender = value;
                                            print("female");
                                            genderType = "أنثي";
                                          });
                                        },
                                      ),
                                      Text("انثي"),
                                    ],
                                  )
                                ],
                              )
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
}

class RoomContent extends StatelessWidget {
  String title;
  String roomCode;

  RoomContent(this.title, this.roomCode);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            iconTheme: new IconThemeData(color: mainColor),
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(color: goldenColor),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(image: decorationImage("g3.jpg")),
            width: screenWidth,
            height: screenHeight,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    RoomContentVideo(title, roomCode)));
                      },
                      child: item("الفيديوهات", Icons.ondemand_video)),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    RoomContentBooks(title, roomCode)));
                      },
                      child: item("المذكرات و الكتب", Icons.local_library)),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StudentAsk(title, roomCode)));
                      },
                      child: item("اسأل سؤال عن المادة", Icons.ondemand_video)),
//                  item("الاسئلة و الامتحانات السابقة", Icons.lock_open)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget item(String title, var icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: mainColor)),
        child: ListTile(
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: mainColor,
          ),
          leading: Icon(
            icon,
            color: mainColor,
            size: 20,
          ),
          title: Text(
            title,
            style: TextStyle(color: mainColor, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class AdminRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("AdminPanal.Rooms")
          .where('show', isEqualTo: "on")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return HndleError(context);
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Loader();

          default:
            return new ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, index) {
                if (snapshot.data.documents.length == 0) {
                  return Text("لا توجد مواد الآن");
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => YoutubePlayerPage2(
                                    snapshot.data.documents[index]['code'])));
                      },
                      child: new Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(7),
                            color:
                                snapshot.data.documents[index]['color'] == null
                                    ? Colors.white30
                                    : Color(getColorHexFromStr(snapshot
                                            .data.documents[index]['color']))
                                        .withOpacity(.3)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents[index]['title']
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: Text(
                                  snapshot.data.documents[index]['name'],
                                  style: TextStyle(color: Colors.white30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
        }
      },
    );
  }
}

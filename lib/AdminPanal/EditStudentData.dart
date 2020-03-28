import 'dart:io';
import 'package:dreslamelshahawy/component/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../AppDrawer.dart';
import '../Decorations.dart';

import '../colors.dart';

class EditStudenAccount extends StatelessWidget {
  String yearcode;
  List yearRooms;
  List yearRoomsVal;

  EditStudenAccount({this.yearcode, this.yearRooms, this.yearRoomsVal});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: appbarColor,
            centerTitle: true,
            title: Text(
              "تعديل بيانات طالب",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(image: decorationImage("bg2.png")),
            width: screenWidth,
            height: screenHeight,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  EditStudenAccountBody(
                    yearcode: yearcode,
                    yearRooms: yearRooms,
                    yearRoomsVal: yearRoomsVal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditStudenAccountBody extends StatefulWidget {
  String yearcode;
  List yearRooms;
  List yearRoomsVal;

  EditStudenAccountBody({this.yearcode, this.yearRooms, this.yearRoomsVal});

  @override
  _EditStudenAccountBodyState createState() => _EditStudenAccountBodyState();
}

class _EditStudenAccountBodyState extends State<EditStudenAccountBody> {
  List<String> roomList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          items(
            yearRooms: widget.yearRooms,
            yearRoomsVal: widget.yearRoomsVal,
          )
        ],
      ),
    );
  }
}

class items extends StatefulWidget {
  List yearRooms;
  List yearRoomsVal;

  items({this.yearRooms, this.yearRoomsVal});

  @override
  _itemsState createState() => _itemsState();
}

class _itemsState extends State<items> {
  String userName;

  @override
  void initState() {
    final roomDataBox = Hive.openBox("roomsData");
    roomDataBox.then((data) {
      setState(() {
        userName = data.get("userName");
      });

      print(data.get("userName"));
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  List room = [];
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  List roomVal = [];
  double padValue = 0;
  Map<int, String> hg;
  List<Paint> paints = <Paint>[
    Paint(1, 'sameh aleem', Colors.red),
    Paint(2, 'Blue', Colors.blue),
    Paint(3, 'Green', Colors.green),
    Paint(4, 'Lime', Colors.lime),
    Paint(5, 'Indigo', Colors.indigo),
    Paint(6, 'Yellow', Colors.yellow)
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5, right: 15, left: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: blueColor, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  maxLength: 8,
                  textAlign: TextAlign.center,
                  controller: idController,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  maxLines: 1,
                  style: TextStyle(color: blueColor, fontSize: 50),
                  decoration: InputDecoration.collapsed(
                      hintText: "",
                      hintStyle: TextStyle(color: blueColor, fontSize: 15)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'ادخل رقم كامل';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          //StudentFirebaseRooms(idController.text),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.yearRooms.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final paint = paints[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      paints[index].selected = !paints[index].selected;
                      if (paints[index].selected) {
                        room.add(widget.yearRooms[index].toString());
                        roomVal.add(widget.yearRoomsVal[index].toString());
                        print(room);
                        print(roomVal);
                      } else {
                        room.remove(widget.yearRooms[index].toString());
                        roomVal.remove(widget.yearRoomsVal[index].toString());
                        print(room);
                        print(roomVal);
                      }
                    });
                  },
                  selected: paints[index].selected,
                  leading: Container(
                    width: 58,
                    height: 108,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: paints[index].colorpicture,
                    ),
                  ),
                  title: Text(
                    widget.yearRooms[index].toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: (paints[index].selected)
                      ? Icon(
                          Icons.check_box,
                          size: 50,
                        )
                      : Icon(Icons.check_box_outline_blank, size: 50),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: RoundedLoadingButton(
              color: blueColor,
              height: 70,
              width: MediaQuery.of(context).size.width * .85,
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  flushBar(context, false,
                      massage: "تأكد من كتابه ID  صحيح ", sec: 10);
                  _btnController.reset();
                  return;
                }

                if (idController.text.length != 8) {
                  flushBar(context, false,
                      massage: "تأكد من ادخال Id صحيح ", sec: 10);
                  _btnController.reset();
                  return;
                }

                if (room.length == 0) {
                  flushBar(context, false,
                      massage: "تأكد من اختيار ماده او اكثر ", sec: 10);
                  _btnController.reset();
                  return;
                }
                //////////////////////////////////////////////
                final FirebaseAuth _newAccountAuth = FirebaseAuth.instance;

                try {
                  Firestore.instance
                      .collection('UsersID')
                      .document(idController.text)
                      .updateData({
                    "updatedBy": userName,
                    "updated at": FieldValue.serverTimestamp(),
                    "roomsName": room,
                    "roomsCode": roomVal
                  });
                  _btnController.reset();
                  flushBar(context, true,
                      massage: "تم تحديث بيانات الطالب بنجاح", sec: 5);
                } on PlatformException catch (e) {
                  print(e.code);
                  String errorType;
                  if (Platform.isAndroid) {
                    switch (e.code) {
                      //ERROR_USER_DISABLED
                      case "ERROR_EMAIL_ALREADY_IN_USE":
                        errorType = "هذا الحساب موجود بالفعل";
                        break;
                      case "ERROR_USER_DISABLED":
                        errorType =
                            " هذا الحساب تم ايقافه من قبل الادارة الرجاء الاتصال بنا ";
                        break;
                      case "ERROR_TOO_MANY_REQUESTS":
                        errorType = "لا يمكن تنفيذ الطلب الان حاول مره اخري";
                        break;
                      case "ERROR_INVALID_EMAIL":
                        errorType = "تأكد من كتابه الايميل بطريقه صحيحة";
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
                        errorType = "This id is already have an account";
                    }
                  }
                  print('The error is $errorType');
                  _btnController.reset();
                  flushBar(context, false, massage: errorType, sec: 5);
                }
              },
              controller: _btnController,
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class StudentFirebaseRooms extends StatelessWidget {
  String id;

  StudentFirebaseRooms(this.id);

  @override
  Widget build(BuildContext context) {
    ////
    return Container(
      child: Column(
        children: <Widget>[
          Text("مواد الطالب الحالية"),
          StreamBuilder(
              stream: Firestore.instance
                  .collection("UsersID")
                  .document(id)
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError)
                  return Text('لا يوجد بيانات لهذا الطالب');
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Select lot');
                  case ConnectionState.waiting:
                    return Text('loading');
                  case ConnectionState.active:
                    {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: snapshot.data["roomsName"] == null
                            ? Text('loading')
                            : ListView.builder(
                                itemCount: snapshot.data["roomsName"] == 0
                                    ? 0
                                    : snapshot.data["roomsName"].length,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  return Text(
                                      snapshot.data["roomsName"][index]);
                                }),
                      );
                    }
                  case ConnectionState.done:
                    return Text('done');
                }
                return Text("null");
              }),
          SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }
}

class Paint {
  final int id;
  final String title;
  final Color colorpicture;
  bool selected = false;

  Paint(this.id, this.title, this.colorpicture);
}

/*List rooms = snapshot.data["roomsName"];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ListView.builder(
                        itemCount: rooms.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return Text(snapshot.data["roomsName"][index]);
                        }),
                  );*/

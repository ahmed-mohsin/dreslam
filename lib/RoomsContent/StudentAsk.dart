import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../PlayerPage.dart';
import '../colors.dart';

class StudentAsk extends StatelessWidget {
  String title;
  String roomCode;

  StudentAsk(this.title, this.roomCode);

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
            iconTheme: new IconThemeData(color: mainColor),
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(color: mainColor),
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
                  Text(
                    "اسأل الدكتور إسلام",
                    style: TextStyle(color: goldenColor, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  AskStudentBody(roomCode)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AskStudentBody extends StatefulWidget {
  String roomCode;
  AskStudentBody(this.roomCode);

  @override
  _AskStudentBodyState createState() => _AskStudentBodyState();
}

class _AskStudentBodyState extends State<AskStudentBody> {
  final formKey = GlobalKey<FormState>();
  final qTitle = TextEditingController();
  final qBody = TextEditingController();
  final name = TextEditingController();
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();

  String userName;
  final roomDataBox = Hive.openBox("roomsData");

  @override
  void initState() {
    roomDataBox.then((data) {
      setState(() {
        userName = data.get("userName");
      });
      print(data.get("userName"));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5, left: 15, right: 15),
              child: Container(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white10),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.white30),
                    controller: qTitle,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        qTitle.text = " ";
                      }
                      return null;
                    },
                    decoration: decorationOftextF("عنوان السؤال"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Container(
                //width: MediaQuery.of(context).size.width - 100,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white10),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.white30),
                    controller: qBody,
                    //keyboardType: TextInputType.number,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ' *ادخل السؤال';
                      }
                      return null;
                    },
                    decoration: decorationOftextF("السؤال"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: RoundedLoadingButton(
                color: mainColor,
                controller: btnController,
                onPressed: () async {
                  if (!formKey.currentState.validate()) {
                    setState(() {});
                    btnController.reset();
                    return;
                  }
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                  print(
                      'Running on ${androidInfo.brand}  ${androidInfo.model}  ${androidInfo.androidId}');
                  DocumentReference documentReference = Firestore.instance
                      .collection("StudentsQ")
                      .document(widget.roomCode)
                      .collection("question")
                      .document();
                  documentReference.setData({
                    "time": FieldValue.serverTimestamp(),
                    'code': qTitle.text,
                    'title': qBody.text,
                    'StudentID': userName,
                    "deviceID":
                        "${androidInfo.brand}${androidInfo.model}${androidInfo.androidId}",
                    'id': documentReference.documentID
                  }).then((data) {
                    btnController.success();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "ارسال السؤال",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  decorationOftextF(String title) {
    return InputDecoration(
        focusColor: Colors.white30,
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        errorStyle:
            TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600),
        labelText: title,
        //hintText: "مثل عنوان العمل , عنوان المنزل",
        labelStyle: TextStyle(color: Colors.white30));
  }
}

/*
class AskStudentBody extends StatelessWidget {
  String roomCode;

  AskStudentBody(this.roomCode);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: Firestore.instance
          .collection("Rooms")
          .document(roomCode)
          .collection("Videos")
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
                  return Text(
                    "لا توجد مواد الآن",
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => YoutubePlayerPage(
                                    snapshot.data.documents[index]['code'])));
                      },
                      child: new Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(7),
                            color: Colors.white30),
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
    ));
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:dreslamelshahawy/player2.dart';
import 'package:dreslamelshahawy/quiz/quiz.dart';
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
          style: TextStyle(fontFamily: 'arn', color: redColor),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: new Text("هل تود تسجيل الخروج من التطبيق ؟",
              style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontFamily: 'arn')),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "إلغاء ",
              style: TextStyle(fontFamily: 'arn', color: redColor),
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
              style: TextStyle(fontFamily: 'arn', color: Colors.black),
            ),
            onPressed: () async {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              roomDataBox.then((data) {
                data.clear();
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    LineIcons.sign_out,
                    color: mainColor,
                  ),
                  onPressed: () {
                    alert();
                  })
            ],
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
      child: Container(
          child: StreamBuilder(
        stream: Firestore.instance
            .collection("Rooms")
            .document("*Visitors")
            .collection("Videos")
            .where('show', isEqualTo: "on")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return HndleError(context);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loader();

            default:
              return Column(
                children: [
                  // MaterialButton(
                  //     color: goldenColor,
                  //     child: Text('click'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context, MaterialPageRoute(builder: (_) => Quiz()));
                  //     }),
                  // MaterialButton(
                  //     color: goldenColor,
                  //     child: Text('ADD QUIZ'),
                  //     onPressed: () {
                  //       Firestore.instance
                  //           .document('/Quizes/1/test1/t1')
                  //           .updateData({
                  //         'QuestionsNumbers':FieldValue.increment(1),
                  //         'question1':'what is ................?',
                  //         'answers1':["a","b","c","d","e"],
                  //         'rightAnswer1':'b',
                  //         'question2':'what is ................?',
                  //         'answers2':["a","b","c","d","e"],
                  //         'rightAnswer2':'c',
                  //         'question3':'what is ................?',
                  //         'answers3':["a","b","c","d","e"],
                  //         'rightAnswer3':'d',
                  //         'question4':'what is ................?',
                  //         'answers4':["a","b","c","d","e"],
                  //         'rightAnswer4':'a',
                  //         'question5':'what is ................?',
                  //         'answers5':["a","b","c","d","e"],
                  //         'rightAnswer5':'e',
                  //         'question6':'what is ................?',
                  //         'answers6':["a","b","c","d","e"],
                  //         'rightAnswer6':'d',
                  //       });
                  //     }),
                  new ListView.builder(
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
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 8, right: 8),
                          child: new Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: mainColor),
                              borderRadius: BorderRadius.circular(7),
                            ),
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
                                        Container(
                                          child: Expanded(
                                            child: Text(
                                              snapshot.data
                                                  .documents[index]['title']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: mainColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.documents[index]
                                              ['name'],
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          " تمت مشاهدته ${snapshot.data.documents[index]['views'].toString()} مرة ",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: mainColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (_) =>
                                            //             YoutubePlayerPage2(
                                            //                 snapshot.data
                                            //                         .documents[
                                            //                     index]['code'])));

                                            Firestore.instance
                                                .collection("Rooms")
                                                .document("*Visitors")
                                                .collection("Videos")
                                                .document(snapshot.data
                                                    .documents[index]['id'])
                                                .updateData({
                                              "views": FieldValue.increment(1)
                                            });
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.play_circle_filled,
                                                color: mainColor,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Text(
                                                  "Player2",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (_) =>
                                            //             YoutubePlayerPage(snapshot
                                            //                     .data.documents[
                                            //                 index]['code'])));
                                            //
                                            // Firestore.instance
                                            //     .collection("Rooms")
                                            //     .document("*Visitors")
                                            //     .collection("Videos")
                                            //     .document(snapshot.data
                                            //         .documents[index]['id'])
                                            //     .updateData({
                                            //   "views": FieldValue.increment(1)
                                            // });
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.play_circle_filled,
                                                color: mainColor,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Text(
                                                  "Player1",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
          }
        },
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
  bool showAlert;

  @override
  void initState() {
    final roomDataBox = Hive.openBox("roomsData");

    roomDataBox.then((data) {
      setState(() {
        roomsName = data.get("roomsName");
        userName = data.get("userName");
        roomsCode = data.get("roomsCode");
        UID = data.get("UID");
        showAlert = data.get("showalert");
        print("show alert == $showAlert");
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
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (_) => RoomContent(roomsName[index].toString(),
//                          roomsCode[index].toString()),
//                    ));

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomContent(roomsName[index].toString(),
                          roomsCode[index].toString()),
                    ));

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
                      border: Border.all(color: mainColor),
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
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) =>
                        //             RoomContentBooks(title, roomCode)));
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => YoutubePlayerPage2(
                        //             snapshot.data.documents[index]['code'])));
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

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreslamelshahawy/Models/ModelExam.dart';
import 'package:dreslamelshahawy/UserScreens/Exam.dart';
import 'package:dreslamelshahawy/component/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;
import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../PlayerPage.dart';
import '../colors.dart';
import '../player2.dart';

class RoomContentVideo extends StatelessWidget {
  String title;
  String roomCode;

  RoomContentVideo(this.title, this.roomCode);

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
                    "الفيديوهات المتاحة",
                    style: TextStyle(color: goldenColor, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Divider(
                      color: goldenColor,
                    ),
                  ),
                  RoomContentVideoStreamBuilder(roomCode)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoomContentVideoStreamBuilder extends StatefulWidget {
  String roomCode;

  RoomContentVideoStreamBuilder(this.roomCode);

  final roomDataBox = Hive.openBox("roomsData");

  @override
  _RoomContentVideoStreamBuilderState createState() =>
      _RoomContentVideoStreamBuilderState();
}

class _RoomContentVideoStreamBuilderState
    extends State<RoomContentVideoStreamBuilder> {
  String UID = "";

  @override
  void initState() {
    final roomDataBox = Hive.openBox("roomsData");

    roomDataBox.then((data) {
      setState(() {
        UID = data.get("UID");
      });

      print(UID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: Firestore.instance
          .collection("Rooms")
          .document("*${widget.roomCode}")
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
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        snapshot.data.documents[index]['title']
                                            .toString(),
                                        style: TextStyle(
                                            color: mainColor, fontSize: 18),
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
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.documents[index]['name'],
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
                            InkWell(
                              onTap: () async {
                                if (snapshot.data.documents[index]
                                        ['needtest'] ==
                                    true) {
                                  ///Rooms/*101nozm/Videos/9pRz834i5vKOrOGUUYtd/tests/12012020
                                  String url =
                                      snapshot.data.documents[index]['examurl'];
                                  if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceWebView: true,
                                      enableJavaScript: true,
                                      forceSafariVC: true,
                                    ).then((_) {
                                      final snapShot = Firestore.instance
                                          .collection('Rooms')
                                          .document("*${widget.roomCode}")
                                          .collection("Videos")
                                          .document(snapshot
                                              .data.documents[index]['id'])
                                          .collection("tests")
                                          .document(UID)
                                          .setData({"passtest": "true"});
                                    });
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                } else {
                                  flushBar(context, true,
                                      sec: 60,
                                      massage: "لايوجد امتحان لهذه المادة");
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      "Exam",
                                      style: TextStyle(color: mainColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: mainColor,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      if (snapshot.data.documents[index]
                                              ['needtest'] ==
                                          false) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    YoutubePlayerPage(snapshot
                                                            .data
                                                            .documents[index]
                                                        ['code'])));

                                        Firestore.instance
                                            .collection("Rooms")
                                            .document("*${widget.roomCode}")
                                            .collection("Videos")
                                            .document(snapshot
                                                .data.documents[index]['id'])
                                            .updateData({
                                          "views": FieldValue.increment(1)
                                        });
                                      }
                                      print(widget.roomCode);
                                      print(snapshot.data.documents[index]['id']
                                          .toString());
                                      print(UID);

                                      final snapShot = await Firestore.instance
                                          .collection('Rooms')
                                          .document("*${widget.roomCode}")
                                          .collection("Videos")
                                          .document(snapshot
                                              .data.documents[index]['id'])
                                          .collection("tests")
                                          .document(UID)
                                          .get();

                                      if (snapShot == null ||
                                          !snapShot.exists) {
                                        flushBar(context, true,
                                            sec: 60,
                                            massage:
                                                "حل الامتحان الي فوق الأول عشان تقدر تشوف الفيديو");
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    YoutubePlayerPage(snapshot
                                                            .data
                                                            .documents[index]
                                                        ['code'])));

                                        Firestore.instance
                                            .collection("Rooms")
                                            .document("*${widget.roomCode}")
                                            .collection("Videos")
                                            .document(snapshot
                                                .data.documents[index]['id'])
                                            .updateData({
                                          "views": FieldValue.increment(1)
                                        });
                                      }

//                                      DocumentReference checkTest = Firestore
//                                          .instance
//                                          .collection('Rooms')
//                                          .document("*${widget.roomCode}")
//                                          .collection("Videos")
//                                          .document(snapshot.data.documents[index]['id'])
//                                          .collection("tests")
//                                          .document(UID);
//                                      checkTest.get().then((data) {
//                                        if (data == null) {
//                                          print(
//                                              ">>>>>>>>>>>.>>>>>>>> the user dont pass the test");
//                                        } else if (data.data["pass"] == true) {
//                                          print(
//                                              "************************** the user  pass the test");
//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (_) =>
//                                                      YoutubePlayerPage2(
//                                                          snapshot.data
//                                                                  .documents[
//                                                              index]['code'])));
//
//                                          Firestore.instance
//                                              .collection("Rooms")
//                                              .document("*${widget.roomCode}")
//                                              .collection("Videos")
//                                              .document(snapshot
//                                                  .data.documents[index]['id'])
//                                              .updateData({
//                                            "views": FieldValue.increment(1)
//                                          });
//                                        } else if (data.data["pass"] == false) {
//                                          print(
//                                              "///////////////////////////////// the user  didint pass the test marks");
//                                        }
//
//                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "Play The video",
                                            style: TextStyle(color: mainColor),
                                          ),
                                        ),
                                        Icon(
                                          Icons.play_circle_filled,
                                          color: mainColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      print(widget.roomCode);
                                      print(snapshot.data.documents[index]['id']
                                          .toString());
                                      print(UID);

                                      final snapShot = await Firestore.instance
                                          .collection('Rooms')
                                          .document("*${widget.roomCode}")
                                          .collection("Videos")
                                          .document(snapshot
                                              .data.documents[index]['id'])
                                          .collection("tests")
                                          .document(UID)
                                          .get();

                                      if (snapShot == null ||
                                          !snapShot.exists) {
                                        flushBar(context, true,
                                            sec: 60,
                                            massage:
                                                "حل الامتحان الي فوق الأول عشان تقدر تشوف الفيديو");
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    YoutubePlayerPage2(snapshot
                                                            .data
                                                            .documents[index]
                                                        ['code'])));

                                        Firestore.instance
                                            .collection("Rooms")
                                            .document("*${widget.roomCode}")
                                            .collection("Videos")
                                            .document(snapshot
                                                .data.documents[index]['id'])
                                            .updateData({
                                          "views": FieldValue.increment(1)
                                        });
                                      }

//                                      DocumentReference checkTest = Firestore
//                                          .instance
//                                          .collection('Rooms')
//                                          .document("*${widget.roomCode}")
//                                          .collection("Videos")
//                                          .document(snapshot.data.documents[index]['id'])
//                                          .collection("tests")
//                                          .document(UID);
//                                      checkTest.get().then((data) {
//                                        if (data == null) {
//                                          print(
//                                              ">>>>>>>>>>>.>>>>>>>> the user dont pass the test");
//                                        } else if (data.data["pass"] == true) {
//                                          print(
//                                              "************************** the user  pass the test");
//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (_) =>
//                                                      YoutubePlayerPage2(
//                                                          snapshot.data
//                                                                  .documents[
//                                                              index]['code'])));
//
//                                          Firestore.instance
//                                              .collection("Rooms")
//                                              .document("*${widget.roomCode}")
//                                              .collection("Videos")
//                                              .document(snapshot
//                                                  .data.documents[index]['id'])
//                                              .updateData({
//                                            "views": FieldValue.increment(1)
//                                          });
//                                        } else if (data.data["pass"] == false) {
//                                          print(
//                                              "///////////////////////////////// the user  didint pass the test marks");
//                                        }
//
//                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "Play The video",
                                            style: TextStyle(color: mainColor),
                                          ),
                                        ),
                                        Icon(
                                          Icons.play_circle_filled,
                                          color: mainColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (_) => Examm()));
                                },
                                child: Text(""))
                          ],
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

class Examm extends StatefulWidget {
  @override
  _ExammState createState() => _ExammState();
}

class _ExammState extends State<Examm> {
  Future<ModelExam> fetchAlbum() async {
    final response =
    await http.get('http://qzcorner.com/api/exam/3');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ModelExam.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load exam');
    }
  }
  Future<ModelExam> futureExam;

  @override
  void initState() {
    super.initState();
    futureExam = fetchAlbum();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<ModelExam>(
          future: futureExam,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Text(snapshot.data.data.title+" Exam"),
                  ListView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap: true ,itemCount: snapshot.data.data.mcQuestions.length,itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(snapshot.data.data.mcQuestions[index].question+"?"),
                        Text(snapshot.data.data.mcQuestions[index].choiceA),
                        Text(snapshot.data.data.mcQuestions[index].choiceB),
                        Text(snapshot.data.data.mcQuestions[index].choiceC),
                        Text(snapshot.data.data.mcQuestions[index].choiceD),
                        Text(snapshot.data.data.mcQuestions[index].rightAnswer,style: TextStyle(color: redColor),),

                      ],),
                    );
                  }),
                  ListView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap: true ,itemCount: snapshot.data.data.tfQuestions.length,itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data.data.tfQuestions[index].question+"?"),
                          Text("true"),
                          Text("false"),
                          Text(snapshot.data.data.tfQuestions[index].rightAnswer,style: TextStyle(color: redColor),),

                        ],),
                    );
                  })
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

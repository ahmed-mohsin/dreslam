import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../PlayerPage.dart';
import '../colors.dart';

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
          drawer: AppDrawer(),
          appBar: AppBar(
            iconTheme: new IconThemeData(color: redColor),
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(color: redColor),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(image: decorationImage("bg.png")),
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
                      color: Colors.red,
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

class RoomContentVideoStreamBuilder extends StatelessWidget {
  String roomCode;

  RoomContentVideoStreamBuilder(this.roomCode);

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

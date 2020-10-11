import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreslamelshahawy/AdminPanal/rooms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../colors.dart';
import 'AddBook.dart';
import 'AddVideo.dart';
import 'AdminAsk.dart';
import 'CreateStudentAcount.dart';
import 'EditStudentData.dart';

class Years extends StatelessWidget {
  String type;
  String title;

  Years(this.type, this.title);

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
            backgroundColor: greyblackColor,
            centerTitle: true,
            title: Text(
              title,
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
                  YearsBody(type),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class YearsBody extends StatefulWidget {
  String type;

  YearsBody(this.type);

  @override
  _YearsBodyState createState() => _YearsBodyState();
}

class _YearsBodyState extends State<YearsBody> {
  @override
  Widget build(BuildContext context) {
    print(widget.type);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              shadowColor: Colors.red[100],
              borderRadius: BorderRadiusDirectional.circular(20),
              elevation: 5,
              color: greyblackColor,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AdminAddVideoProfile("Visitors", "Visitors")));
                },
                child: Text(
                  "Visitors",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          yearItem("الأولي", "101", r101, r101val),
          yearItem("الثانية", "102", r102, r102val),
          yearItem("الثالثة", "103", r103, r103val),
          yearItem("الرابعة", "104", r104, r104val),
        ],
      ),
    );
  }

  Widget yearItem(
      String title, String yearcode, List yearRooms, List yearRoomsVal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        shadowColor: Colors.red[100],
        borderRadius: BorderRadiusDirectional.circular(20),
        elevation: 5,
        color: greyblackColor,
        child: MaterialButton(
          onPressed: () {
            if (widget.type == "newData2021") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => View2021Data(title)));
            }
            if (widget.type == "new") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CreateStudenAccount(
                            yearcode: yearcode,
                            yearRooms: yearRooms,
                            yearRoomsVal: yearRoomsVal,
                          )));
            }
            if (widget.type == "videos") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdminAddVideo(
                            yearcode: yearcode,
                            yearRooms: yearRooms,
                            yearRoomsVal: yearRoomsVal,
                            yearTitle: title,
                          )));
            }
            if (widget.type == "books") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdminAddBook(
                            yearcode: yearcode,
                            yearRooms: yearRooms,
                            yearRoomsVal: yearRoomsVal,
                            yearTitle: title,
                          )));
            }
            if (widget.type == "edit") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditStudenAccount(
                            yearcode: yearcode,
                            yearRooms: yearRooms,
                            yearRoomsVal: yearRoomsVal,
                          )));
            }
            if (widget.type == "ask") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdminAskBody(
                            yearcode: yearcode,
                            yearRooms: yearRooms,
                            yearRoomsVal: yearRoomsVal,
                          )));
            }
          },
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class View2021Data extends StatelessWidget {
  String _yearName;

  View2021Data(this._yearName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyblackColor,
        centerTitle: true,
        title: Text(
          _yearName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: Firestore.instance.collection(_yearName).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return HndleError(context);
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Loader();

                  default:
                    return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        if (snapshot.data.documents.length == 0) {
                          return Text("لا توجد مواد الآن");
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 8, right: 8),
                            child: InkWell(
                              onTap: () {},
                              child: new Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: goldenColor),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(9.0),
                                                  child: Text(
                                                    index.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: mainColor),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: greyblackColor,
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                            Text(
                                              snapshot
                                                  .data
                                                  .documents[index]
                                                      ['FormuserMail']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: mainColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: goldenColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, left: 20, right: 20),
                                        child: Text(
                                          snapshot.data.documents[index]
                                              ['FormuserMobile'],
                                          style: TextStyle(color: mainColor),
                                        ),
                                      ),
                                      Divider(
                                        color: goldenColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, left: 20, right: 20),
                                        child: Text(
                                          snapshot.data.documents[index]
                                              ['FormuserName'],
                                          style: TextStyle(color: mainColor),
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
            ),
          ),
        ),
      ),
    );
  }
}

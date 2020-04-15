import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../colors.dart';
import '../player2.dart';

class StudentsData extends StatefulWidget {
  @override
  _StudentsDataState createState() => _StudentsDataState();
}

class _StudentsDataState extends State<StudentsData> {
//  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: TabBarView(
              children: [NewData(), OldData("hg", "hg")],
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Students Data",
                style: TextStyle(color: greenColor),
              ),
              backgroundColor: Colors.black,
              bottom: TabBar(
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: redColor,
                unselectedLabelColor: Colors.white,
                isScrollable: true,
                indicator: MD2Indicator(
                  indicatorSize: MD2IndicatorSize.full,
                  indicatorHeight: 3,
                  indicatorColor: redColor,
                ),
                tabs: <Widget>[
                  Tab(
                    text: "جديد",
                  ),
                  Tab(
                    text: "قديم",
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

class NewData extends StatefulWidget {
  @override
  _NewDataState createState() => _NewDataState();
}

class _NewDataState extends State<NewData> {
//  getData().then((val){
//  if(val.documents.length > 0){
//  print(val.documents[0].data["field"]);
//  }
//  else{
//  print("Not Found");
//  }
//  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    ///UsersData/0GGQ7F2ez0eQJxK0BqKm
    return StreamBuilder(
      stream: Firestore.instance.collection("NewUsersData").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Text(
                                            index.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: mainColor),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: greyblackColor,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents[index]['userName']
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
                                  snapshot.data.documents[index]['userMobile'],
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
                                  snapshot.data.documents[index]['class'],
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
                                  snapshot.data.documents[index]['userMail'],
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
    );
  }
}

class OldData extends StatefulWidget {
  String yearCode;
  String title;

  OldData(this.yearCode, this.title);

  @override
  _OldDataState createState() => _OldDataState();
}

class _OldDataState extends State<OldData> {
//  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: Firestore.instance.collection("UsersData").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    padding:
                    const EdgeInsets.only(bottom: 8, left: 8, right: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Text(
                                            index.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: mainColor),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: greyblackColor,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents[index]['userName']
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
                                  snapshot.data.documents[index]['userMobile'],
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
                                  snapshot.data.documents[index]['class'],
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
                                  snapshot.data.documents[index]['userMail'],
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AppDrawer.dart';
import 'Decorations.dart';
import 'HandleConnectionerror.dart';
import 'Loader.dart';
import 'PlayerPage.dart';
import 'colors.dart';

class News extends StatelessWidget {
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
              "الأخبار",
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
                  Categorieslist(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Categorieslist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("News")
          .where('show', isEqualTo: "on")
          .orderBy("id")
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
                                child: Text(
                                  snapshot.data.documents[index]['title']
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:mainColor),
                                ),
                              ),
                              Divider(
                                color: goldenColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, left: 20, right: 20),
                                child: Text(
                                  snapshot.data.documents[index]['desc'],
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

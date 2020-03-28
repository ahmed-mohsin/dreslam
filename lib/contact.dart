import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AppDrawer.dart';
import 'Decorations.dart';
import 'HandleConnectionerror.dart';
import 'Loader.dart';
import 'colors.dart';

class Contact extends StatelessWidget {
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
              "اتصل بنا",
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
          .collection("contact")
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
                  return Text("لا توجد ارقام الآن");
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: InkWell(
                      onTap: () {},
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
                                child: Text(
                                  snapshot.data.documents[index]['title']
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents[index]['numbers'],
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
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

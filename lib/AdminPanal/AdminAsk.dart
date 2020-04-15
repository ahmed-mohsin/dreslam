import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../PlayerPage.dart';
import '../colors.dart';

class AdminAsk extends StatelessWidget {
  String yearcode;
  List yearRooms;
  List yearRoomsVal;
  String yearTitle;

  AdminAsk({this.yearcode, this.yearRooms, this.yearRoomsVal, this.yearTitle});

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
            backgroundColor: blueColor,
            centerTitle: true,
            title: Text(
              yearTitle,
              style: TextStyle(color: Colors.red),
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
                  AdminAskBody(
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

class AdminAskBody extends StatefulWidget {
  String yearcode;
  List yearRooms;
  List yearRoomsVal;

  AdminAskBody({this.yearcode, this.yearRooms, this.yearRoomsVal});

  @override
  _AdminAskBodyState createState() => _AdminAskBodyState();
}

class _AdminAskBodyState extends State<AdminAskBody> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: blueColor,
          centerTitle: true,
          title: Text(
            "",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: widget.yearRooms.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return yearItem(
                widget.yearRooms[index],
                widget.yearRoomsVal[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget yearItem(String title, String yearCode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        shadowColor: Colors.red[100],
        borderRadius: BorderRadiusDirectional.circular(20),
        elevation: 5,
        color: blueColor,
        child: MaterialButton(
          onPressed: () {
            print(yearCode);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AdminAskProfile(yearCode, title)));
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

class AdminAskProfile extends StatefulWidget {
  String yearCode;
  String title;

  AdminAskProfile(this.yearCode, this.title);

  @override
  _AdminAskProfileState createState() => _AdminAskProfileState();
}

class _AdminAskProfileState extends State<AdminAskProfile> {
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
            body: Container(
              decoration: BoxDecoration(image: decorationImage("bg2.png")),
              width: screenWidth,
              height: screenHeight,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("StudentsQ")
                      .document(widget.yearCode)
                      .collection("question")
                      .orderBy("time",descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return HndleError(context);
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loader();

                      default:
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (_, index) {
                              if (snapshot.data.documents.length == 0) {
                                return Text(
                                  "لا توجد أسئلة الآن",
                                  style: TextStyle(color: Colors.red),
                                );
                              } else {
                                Timestamp t =
                                    snapshot.data.documents[index]['time'];
                                DateTime time = t.toDate();
                                print(time.toString());
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8),
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(7),
                                        color: Colors.white70),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Firestore.instance
                                                        .collection("StudentsQ")
                                                        .document(
                                                            widget.yearCode)
                                                        .collection("question")
                                                        .document(snapshot
                                                            .data
                                                            .documents[index]
                                                                ['id']
                                                            .toString())
                                                        .delete();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors.grey
                                                            .withAlpha(100)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(
                                                      "from ${snapshot.data.documents[index]['StudentID']}",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      "at  ${time.toString()}",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              snapshot.data.documents[index]
                                                  ['code'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              snapshot.data.documents[index]
                                                  ['title'],
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: blueColor),
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
                        );
                    }
                  },
                ),
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: blueColor,
            ),
          ),
        ),
      ),
    );
  }
}

class addNewVideo extends StatefulWidget {
  String yearCode;

  addNewVideo(this.yearCode);

  @override
  _addNewVideoState createState() => _addNewVideoState();
}

class _addNewVideoState extends State<addNewVideo> {
  final formKey = GlobalKey<FormState>();
  final code = TextEditingController();
  final title = TextEditingController();
  final name = TextEditingController();

  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Container(
                    child: TextFormField(
                      controller: code,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ' *اكتب الكود';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                          labelText: "كود اليوتيوب",
                          labelStyle: TextStyle(color: greenColor)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Container(
                    child: TextFormField(
                      controller: title,
                      //keyboardType: TextInputType.number,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ' *ادخل الوصف';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                          labelText: "اسم الفيديو",
                          labelStyle: TextStyle(color: greenColor)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Container(
                    child: TextFormField(
                      controller: name,
                      //keyboardType: TextInputType.number,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ' *ادخل وصف الفيديو';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                          labelText: "ادخل وصف الفيديو",
                          labelStyle: TextStyle(color: greenColor)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: RoundedLoadingButton(
                    color: greenColor,
                    controller: btnController,
                    onPressed: () async {
                      if (!formKey.currentState.validate()) {
                        setState(() {});
                        btnController.reset();
                        return;
                      }
                      DocumentReference documentReference = Firestore.instance
                          .collection("Rooms")
                          .document(widget.yearCode)
                          .collection("Videos")
                          .document();
                      documentReference.setData({
                        'code': code.text,
                        'show': "on",
                        'title': title.text,
                        'name': name.text,
                        'views': 0,
                        'id': documentReference.documentID
                      }).then((data) {
                        btnController.success();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "اضافه فيديو جديد",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

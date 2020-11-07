import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreslamelshahawy/RoomsContent/RoomsContentBooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../PlayerPage.dart';
import '../colors.dart';

class AdminAddBook extends StatelessWidget {
  String yearcode;
  List yearRooms;
  List yearRoomsVal;
  String yearTitle;

  AdminAddBook(
      {this.yearcode, this.yearRooms, this.yearRoomsVal, this.yearTitle});

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
                  AdminAddBookBody(
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

class AdminAddBookBody extends StatefulWidget {
  String yearcode;
  List yearRooms;
  List yearRoomsVal;

  AdminAddBookBody({this.yearcode, this.yearRooms, this.yearRoomsVal});

  @override
  _AdminAddBookBodyState createState() => _AdminAddBookBodyState();
}

class _AdminAddBookBodyState extends State<AdminAddBookBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.yearRooms.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return yearItem(
            widget.yearRooms[index],
            widget.yearRoomsVal[index],
          );
        },
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
                    builder: (_) => AdminAddBookProfile(yearCode, title)));
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

class AdminAddBookProfile extends StatefulWidget {
  String yearCode;
  String title;

  AdminAddBookProfile(this.yearCode, this.title);

  @override
  _AdminAddBookProfileState createState() => _AdminAddBookProfileState();
}

class _AdminAddBookProfileState extends State<AdminAddBookProfile> {
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
              children: [
                Container(
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
                        SizedBox(
                          height: 10,
                        ),
                        AdminRoomContentBookStreamBuilder(widget.yearCode)
                      ],
                    ),
                  ),
                ),
                addNewBook(widget.yearCode),
              ],
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.title,
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
                    text: "تعديل و الغاء كتاب",
                  ),
                  Tab(
                    text: " إضافة كتاب جديد",
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

class AdminRoomContentBookStreamBuilder extends StatelessWidget {
  String roomCode;

  AdminRoomContentBookStreamBuilder(this.roomCode);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: Firestore.instance
          .collection("Rooms")
          .document("*$roomCode")
          .collection("Books")
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
                          borderRadius: BorderRadiusDirectional.circular(7),
                          color: snapshot.data.documents[index]['show']
                                      .toString() ==
                                  "on"
                              ? Colors.green[400]
                              : Colors.red[400]),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => PdfReader(
                                //             snapshot
                                //                 .data.documents[index]['title']
                                //                 .toString(),
                                //             snapshot
                                //                 .data.documents[index]['code']
                                //                 .toString())));
                              },
                              child: Padding(
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
                            Divider(
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                MaterialButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      if (snapshot.data.documents[index]['show']
                                              .toString() ==
                                          "on") {
                                        Firestore.instance
                                            .collection("Rooms")
                                            .document("*$roomCode")
                                            .collection("Books")
                                            .document(snapshot
                                                .data.documents[index]['id']
                                                .toString())
                                              ..updateData({"show": "off"});
                                      } else {
                                        Firestore.instance
                                            .collection("Rooms")
                                            .document("*$roomCode")
                                            .collection("Books")
                                            .document(snapshot
                                                .data.documents[index]['id']
                                                .toString())
                                              ..updateData({"show": "on"});
                                      }
                                    },
                                    child: Text(
                                      "hide or  show",
                                      style: TextStyle(color: Colors.white),
                                    )),
//                                MaterialButton(
//                                    hoverColor: Colors.black87,
//                                    onPressed: () {},
//                                    child: Text("Edit",
//                                        style: TextStyle(color: Colors.white))),
                                Column(
                                  children: <Widget>[
                                    Text("عدد المشاهدات",style: TextStyle(color: Colors.white),),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(snapshot
                                            .data.documents[index]['views']
                                            .toString(),style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                ),
                                MaterialButton(
                                    color: Colors.black,
                                    hoverColor: Colors.black87,
                                    onPressed: () {
                                      Firestore.instance
                                          .collection("Rooms")
                                          .document("*$roomCode")
                                          .collection("Books")
                                          .document(snapshot
                                              .data.documents[index]['id']
                                              .toString())
                                          .delete();
                                    },
                                    child: Text("Delete",
                                        style: TextStyle(color: Colors.white))),
                              ],
                            )
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

class addNewBook extends StatefulWidget {
  String yearCode;

  addNewBook(this.yearCode);

  @override
  _addNewBookState createState() => _addNewBookState();
}

class _addNewBookState extends State<addNewBook> {
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
                          labelText: "كود الكتاب",
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
                          labelText: "اسم الكتاب",
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
                          return ' *ادخل وصف الكتاب';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                          labelText: "ادخل وصف الكتاب",
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
                          .document("*${widget.yearCode}")
                          .collection("Books")
                          .document();
                      documentReference.setData({
                        //https://drive.google.com/u/0/uc?id=1kZzVU49gm0Kgnqgzt2pqsqiTpuFefJkx
                        //https://drive.google.com/u/0/uc?id=1kZzVU49gm0Kgnqgzt2pqsqiTpuFefJkx
                        'code':
                            "https://drive.google.com/u/0/uc?id=${code.text}",
                        'show': "on",
                        'title': title.text,
                        'name': name.text,
                        'views': 0,
                        'id': documentReference.documentID,
                        "createdAt": FieldValue.serverTimestamp(),
                      }).then((data) {
                        btnController.success();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "اضافه كتاب جديد",
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

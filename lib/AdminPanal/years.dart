import 'package:dreslamelshahawy/AdminPanal/AddVideo.dart';
import 'package:dreslamelshahawy/AdminPanal/rooms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../AppDrawer.dart';
import '../Decorations.dart';
import '../colors.dart';
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
          yearItem("الفرقة الرابعة", "104", r104, r104val),
          yearItem("الفرقة التالتة", "103", r103, r103val),
          yearItem("الفرقة التانية", "102", r102, r102val),
          yearItem("الفرقة الاولي", "101", r101, r101val),
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
          },
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

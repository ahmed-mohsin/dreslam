import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../AppDrawer.dart';
import '../Decorations.dart';
import '../colors.dart';
import 'AccountsActivations.dart';
import 'EditStudentData.dart';
import 'years.dart';

class AdminBoard extends StatelessWidget {
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
            backgroundColor: appbarColor,
            centerTitle: true,
            title: Text(
              "Admin panal",
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
                  AdminBoardBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminBoardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Material(
            color: blueColor,
            elevation: 20,
            borderRadius: BorderRadiusDirectional.circular(10),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * .75,
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Years("new", "انشاء حساب جديد")));
              },
              child: Text(
                "انشاء حساب جديد لطالب",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: blueColor,
              elevation: 10,
              borderRadius: BorderRadiusDirectional.circular(10),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .75,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              Years("edit", "تعديل بيانات الطلاب")));
                },
                child: Text(
                  "تعديل بيانات طالب",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: blueColor,
              elevation: 10,
              borderRadius: BorderRadiusDirectional.circular(10),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .75,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Years("videos", "اداره الفيديوهات")));
                },
                child: Text(
                  "إضافه او الغاء فيديو",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: blueColor,
              elevation: 10,
              borderRadius: BorderRadiusDirectional.circular(10),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .75,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Years("books", "اداره الكتب")));
                },
                child: Text(
                  "إضافه او الغاء كتاب او مذكره",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: blueColor,
              elevation: 10,
              borderRadius: BorderRadiusDirectional.circular(10),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .75,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Years("ask", "أسئلة الطلبة")));
                },
                child: Text(
                  "أسئلة الطلبة",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: blueColor,
              elevation: 10,
              borderRadius: BorderRadiusDirectional.circular(10),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * .75,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AccountsActivation()));
                },
                child: Text(
                  "تفعيل الحسابات",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

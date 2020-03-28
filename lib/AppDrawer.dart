import 'dart:developer';
import 'dart:ui';

import 'package:dreslamelshahawy/schedeule.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'AdminPanal/AdminBoard.dart';
import 'Decorations.dart';
import 'Rooms.dart';
import 'colors.dart';
import 'contact.dart';
import 'main.dart';
import 'news.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String loginTypo;
  String userName;
  final roomDataBox = Hive.openBox("roomsData");

  @override
  void initState() {
    roomDataBox.then((data) {
      setState(() {
        loginTypo = data.get("LoginType");
        userName = data.get("userName");
      });
      print(data.get("LoginType"));
      print(data.get("userName"));
    });
    super.initState();
  }

  var color1 = Color(0xffb15202b);

  var color2 = Color(0xff21303d);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      color: loginTypo == "admin" ? greyblackColor : Colors.black,
      child: Column(
        children: <Widget>[
          Container(
            //height: loginTypo == "admin" ? 350 : 280,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 40, bottom: 20),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration:
                        BoxDecoration(image: decorationImage("logo.png")),
                  ),
                ),
                Text(
                  userName,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.white),
                ),
                Divider(
                  color: redColor,
                  thickness: 4,
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    loginTypo == "admin"
                        ? InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminBoard()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: darwerListItem(
                              title: "Admin Board",
                              icon1: Icons.settings,
                            ),
                          )
                        : Container(),
                    loginTypo == "admin"
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => Rooms()));
                            },
                            child: darwerListItem(
                              title: "المواد",
                              icon1: Icons.school,
                            ),
                          ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => News()));
                      },
                      child: darwerListItem(
                        title: "الاخبار",
                        icon1: Icons.live_tv,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => schedule()));
                      },
                      child: darwerListItem(
                        title: "المواعيد",
                        icon1: Icons.calendar_today,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Contact()));
                      },
                      child: darwerListItem(
                        title: "اتصل بنا",
                        icon1: Icons.contact_phone,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        roomDataBox.then((data) {
                          data.clear();
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: darwerListItem(
                        title: "تسجيل خروج",
                        icon1: Icons.remove_circle_outline,
                      ),
                    ),
                    Image.asset(
                      "assets/logo2.png",
                      color: goldenColor,
                      height: 90,
                      width: 90,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class darwerListItem extends StatelessWidget {
  String title;
  var icon1, icon2;

  darwerListItem({this.title, this.icon1, this.icon2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadiusDirectional.circular(10)),
        child: ListTile(
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          leading: Icon(
            icon1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:dreslamelshahawy/schedeule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'Rooms.dart';
import 'colors.dart';
import 'contact.dart';
import 'news.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
     Rooms(),
    News(),
    schedule(),
    Contact()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black87, ),
        child: GNav(color: goldenColor,backgroundColor: Colors.black87,
            gap: 8,
            activeColor: Colors.lime,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            duration: Duration(milliseconds: 800),
            tabBackgroundColor: Colors.black87,
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.newspaper_o,
                text: 'News',
              ),
              GButton(
                icon: LineIcons.calendar,
                text: 'Calender',
              ),
              GButton(
                icon: LineIcons.phone,
                text: 'Contact Us',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
      ),
    );
  }
}
//class HomePage extends StatefulWidget {
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  static String nameFromCash, image, phone, email;
//
//  int _selectedIndex = 0;
//
//  TextStyle optionStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
//
//  bool logged;
//  List<Widget> _widgetOptions = <Widget>[
//    Rooms(),
//    News(),
//    schedule(),
//    schedule(),
//  ];
//
////  List<Widget> nonAuth = <Widget>[
////    Menu(),
////    Services(),
////    Market(),
////    Cart(),
////  ];
//
//  void _onItemTapped(int index) {
//    setState(() {
//      _selectedIndex = index;
//    });
//  }
//
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//  @override
//  Widget build(BuildContext context) {
//    PageController _myPage = PageController(initialPage: 0);
//    return WillPopScope(
//      onWillPop: () {
//        alert();
//      },
//      child: Directionality(
//        textDirection: TextDirection.rtl,
//        child: Scaffold(
//          key: _scaffoldKey,
//          drawer: AppDrawer(),
//          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//          bottomNavigationBar: BottomAppBar(
//            child: Container(
//              height: 75,
//              child: Row(
//                mainAxisSize: MainAxisSize.max,
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  IconButton(
//                    iconSize: 30.0,
//                    icon: Icon(Icons.menu),
//                    onPressed: () {
//                      _scaffoldKey.currentState.openDrawer();
//                    },
//                  ),
//
//                  IconButton(
//                    iconSize: 30.0,
//                    icon: Icon(Icons.calendar_today),
//                    onPressed: () {
//                      setState(() {
//                        _myPage.jumpToPage(2);
//                      });
//                    },
//                  ),
//                  IconButton(
//                    iconSize: 30.0,
//                    icon: Icon(Icons.library_books),
//                    onPressed: () {
//                      setState(() {
//                        _myPage.jumpToPage(1);
//                      });
//                    },
//                  ),
//                  IconButton(
//                    iconSize: 30.0,
//                    icon: Icon(Icons.home),
//                    onPressed: () {
//                      setState(() {
//                        _myPage.jumpToPage(0);
//                      });
//                    },
//                  ),
//                ],
//              ),
//            ),
//          ),
//          body: PageView(
//            controller: _myPage,
//            onPageChanged: (int) {
//              print('Page Changes to index $int');
//            },
//            children: <Widget>[
//              Rooms(),
//              News(),
//              schedule(),
//              schedule()
//            ],
//            physics: NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
//          ),
//
//        ),
//      ),
//    );
//  }
//}

/*BottomNavigationBar(
            backgroundColor: Colors.black87,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  'الرئيسية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library),
                title: Text(
                  'الاخبار',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text(
                  'المواعيد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text(
                  'المزيد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: greenColor,
            onTap: _onItemTapped,
            elevation: 1,
          )*/
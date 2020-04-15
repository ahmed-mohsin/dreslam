import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutube/flutube.dart';
import 'Decorations.dart';
import 'Rooms.dart';
import 'colors.dart';

class YoutubePlayerPage2 extends StatefulWidget {
  String id;

  YoutubePlayerPage2(this.id);

  @override
  _YoutubePlayerPage2State createState() => _YoutubePlayerPage2State();
}

class _YoutubePlayerPage2State extends State<YoutubePlayerPage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(image: decorationImage("g3.jpg")),
        child: Container(
          child: FluTube(
            'https://www.youtube.com/watch?v=${widget.id}',
            aspectRatio: 16 / 9,
            autoPlay: true,
            looping: false,
            allowMuting: true,
            showControls: true,
            allowFullScreen: true,
            fullscreenByDefault: true,
            showThumb: true,
            placeholder: SpinKitCircle(
              color: goldenColor,
            ),
            onVideoStart: () {},
            onVideoEnd: () {},
          ),
        ),
      ),
    );
  }
}

class TheEnd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: decorationImage("bg3.png")),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(image: decorationImage("logo.png")),
                ),
              ),
              Text(
                "The End \n Thank you for watching",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Container(
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Colors.lightGreenAccent.withOpacity(.2)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "العودة للصفحه الرئيسية",
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Rooms()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

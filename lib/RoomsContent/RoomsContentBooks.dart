import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

import '../AppDrawer.dart';
import '../Decorations.dart';
import '../HandleConnectionerror.dart';
import '../Loader.dart';
import '../PlayerPage.dart';
import '../colors.dart';
import 'package:http/http.dart' as http;

class RoomContentBooks extends StatelessWidget {
  String title;
  String roomCode;

  RoomContentBooks(this.title, this.roomCode);

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
              title,
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
                  Text(
                    "الكتب المتاحة",
                    style: TextStyle(color: goldenColor, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Divider(
                      color: Colors.red,
                    ),
                  ),
                  RoomContentVideoStreamBuilder(roomCode)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoomContentVideoStreamBuilder extends StatelessWidget {
  String roomCode;

  RoomContentVideoStreamBuilder(this.roomCode);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: Firestore.instance
          .collection("Rooms")
          .document(roomCode)
          .collection("Books")
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
                  return Text(
                    "لا توجد مواد الآن",
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PdfReader(
                                    snapshot.data.documents[index]['title']
                                        .toString(),
                                    snapshot.data.documents[index]['code']
                                        .toString())));
                      },
                      child: new Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(7),
                            color: Colors.white30),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.border_color,
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
    ));
  }
}

class PdfReader extends StatefulWidget {
  String title;
  String bookLink;

  PdfReader(this.title, this.bookLink);

  @override
  _PdfReaderState createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(widget.bookLink);
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  void loadPdf() async {
    await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
    print(path);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              path != null
                  ? Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: PdfViewer(
                        filePath: path,
                      ))
                  : Text("تحميل الكتاب"),
              path == null
                  ? RaisedButton(
                      child: Text("عرض الكتاب"),
                      onPressed: loadPdf,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

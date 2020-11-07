// import 'dart:io';
// import 'dart:typed_data';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../AppDrawer.dart';
// import '../Decorations.dart';
// import '../HandleConnectionerror.dart';
// import '../Loader.dart';
// import '../PlayerPage.dart';
// import '../colors.dart';
// import 'package:http/http.dart' as http;
//
// class RoomContentBooks extends StatelessWidget {
//   String title;
//   String roomCode;
//
//   RoomContentBooks(this.title, this.roomCode);
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery
//         .of(context)
//         .size
//         .width;
//     double screenHeight = MediaQuery
//         .of(context)
//         .size
//         .height;
//
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           appBar: AppBar(
//             iconTheme: new IconThemeData(color: goldenColor),
//             backgroundColor: Colors.black,
//             centerTitle: true,
//             title: Text(
//               title,
//               style: TextStyle(color: goldenColor),
//             ),
//           ),
//           body: Container(
//             decoration: BoxDecoration(image: decorationImage("g3.jpg")),
//             width: screenWidth,
//             height: screenHeight,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "الكتب المتاحة",
//                     style: TextStyle(color: goldenColor, fontSize: 20),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Divider(
//                       color: mainColor,
//                     ),
//                   ),
//                   RoomContentVideoStreamBuilder(roomCode)
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class RoomContentVideoStreamBuilder extends StatelessWidget {
//   String roomCode;
//
//   RoomContentVideoStreamBuilder(this.roomCode);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: StreamBuilder(
//           stream: Firestore.instance
//               .collection("Rooms")
//               .document("*$roomCode")
//               .collection("Books")
//               .where('show', isEqualTo: "on").orderBy("createdAt",descending: true)
//               .snapshots(),
//           builder: (BuildContext context,
//               AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) return HndleError(context);
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Loader();
//
//               default:
//                 return new ListView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: snapshot.data.documents.length,
//                   itemBuilder: (_, index) {
//                     if (snapshot.data.documents.length == 0) {
//                       return Text(
//                         "لا توجد مواد الآن",
//                         style: TextStyle(color: Colors.white),
//                       );
//                     } else {
//                       return Padding(
//                         padding:
//                         const EdgeInsets.only(bottom: 8, left: 8, right: 8),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) =>
//                                         PdfReader(
//                                             snapshot.data
//                                                 .documents[index]['title']
//                                                 .toString(),
//                                             snapshot.data
//                                                 .documents[index]['code']
//                                                 .toString())));
//
//                             Firestore.instance
//                                 .collection("Rooms")
//                                 .document("*$roomCode")
//                                 .collection("Books").document(snapshot.data.documents[index]['id'])
//                                 .updateData(
//                                 {"views": FieldValue.increment(1)});
//                           },
//                           child: new Container(
//                             decoration: BoxDecoration(border: Border.all(color: mainColor),
//                                 borderRadius: BorderRadius.circular(7),
//                                 color: Colors.transparent),
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 8),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.all(4.0),
//                                     child: Row(
//                                       children: <Widget>[
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Icon(
//                                             LineIcons.book,
//                                             color: mainColor,
//                                           ),
//                                         ),
//                                         Text(
//                                           snapshot.data
//                                               .documents[index]['title']
//                                               .toString(),
//                                           style: TextStyle(
//                                               color: mainColor,
//                                               fontSize: 18),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Divider(
//                                     color: mainColor,
//                                   ),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.only(left: 30, right: 30),
//                                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: <Widget>[
//                                         Text(
//                                           snapshot.data.documents[index]['name'],
//                                           style: TextStyle(color: Colors.grey
//                                           ),
//                                         ),
//                                         Text(
//                                           " تمت مشاهدته ${snapshot.data.documents[index]['views'].toString()} مرة ",
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 );
//             }
//           },
//         ));
//   }
// }
//
// class PdfReader extends StatefulWidget {
//   String title, code;
//
//   PdfReader(this.title, this.code);
//
//   @override
//   _PdfReaderState createState() => _PdfReaderState();
// }
//
// class _PdfReaderState extends State<PdfReader> {
//   bool _isLoading = true;
//   PDFDocument document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//   }
//
//   loadDocument() async {
//     document = await PDFDocument.fromURL(widget.code);
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: new IconThemeData(color: mainColor),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: Text(
//           widget.title,
//           style: TextStyle(color: mainColor),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(image: decorationImage("g3.jpg")),
//         height: MediaQuery
//             .of(context)
//             .size
//             .height,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         child: Center(
//           child: _isLoading
//               ? Center(child: SpinKitCircle(color: mainColor))
//               : PDFViewer(
//             document: document,
//             zoomSteps: 1,
//             //uncomment below line to preload all pages
//             // lazyLoad: false,
//             // uncomment below line to scroll vertically
//             // scrollDirection: Axis.vertical,
//
//             //uncomment below code to replace bottom navigation with your own
//             /* navigationBuilder:
//                         (context, page, totalPages, jumpToPage, animateToPage) {
//                       return ButtonBar(
//                         alignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           IconButton(
//                             icon: Icon(Icons.first_page),
//                             onPressed: () {
//                               jumpToPage()(page: 0);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.arrow_back),
//                             onPressed: () {
//                               animateToPage(page: page - 2);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.arrow_forward),
//                             onPressed: () {
//                               animateToPage(page: page);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.last_page),
//                             onPressed: () {
//                               jumpToPage(page: totalPages - 1);
//                             },
//                           ),
//                         ],
//                       );
//                     }, */
//           ),
//         ),
//       ),
//     );
//   }
// }

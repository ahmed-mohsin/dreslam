import 'package:flutter/material.dart';

import 'colors.dart';

Widget HndleError(context) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * .75,
          decoration: BoxDecoration(border: Border.all(color: greenColor)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error,
                    color: greenColor,
                    size: 40,
                  ),
                ),
                Text(
                  "Connection error , Please Make Sure You Are Connected To The Internet, You Will Not Be Able To Complete The Process This Way .",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: greenColor),
                ),
              ],
            ),
          ),
        ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(15.0),
//                                      child: Text(
//                                        " OR ",
//                                        style: TextStyle(color: Colors.white),
//                                      ),
//                                    ),
//                                    InkWell(
//                                      onTap: () {
//                                        Navigator.pushNamed(context, "/events");
//                                      },
//                                      child: Card(
//                                        color: Colors.white10,
//                                        child: Container(
//                                          decoration: BoxDecoration(
//                                              color: Colors.white10,
//                                              borderRadius:
//                                                  BorderRadius.circular(10)),
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(5.0),
//                                            child: Column(
//                                              children: <Widget>[
//                                                Icon(
//                                                  Icons.replay,
//                                                  size: 50,
//                                                  color: goldenColor,
//                                                ),
//                                                Text(
//                                                  " Reload again",
//                                                  style: TextStyle(
//                                                      color: goldenColor,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    )
      ],
    ),
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreslamelshahawy/component/flushbar.dart';
import 'package:flutter/material.dart';

import '../AppDrawer.dart';
import '../Decorations.dart';
import '../colors.dart';

class AccountsActivation extends StatelessWidget {
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
              "Activate / accounts",
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
                  AccountsActivationBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccountsActivationBody extends StatefulWidget {
  @override
  _AccountsActivationBodyState createState() => _AccountsActivationBodyState();
}

class _AccountsActivationBodyState extends State<AccountsActivationBody> {
  final _formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  bool loadData;
  String userIdFromFirebase ;
  String mobileIdFromFirebase ;


  @override
  void initState() {
    loadData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5, right: 15, left: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: blueColor, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    maxLength: 8,
                    textAlign: TextAlign.center,
                    controller: idController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    maxLines: 1,
                    style: TextStyle(color: blueColor, fontSize: 50),
                    decoration: InputDecoration.collapsed(
                        hintText: "",
                        hintStyle: TextStyle(color: blueColor, fontSize: 15)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'ادخل رقم كامل';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Search with id",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                color: greyblackColor,
                onPressed: () {
                  if (idController.text.length < 8) {
                    setState(() {
                      loadData = false;
                    });
                    flushBar(context, false,
                        massage: "تاكد من ادخال رقم كامل", sec: 60);
                  } else {
                    DocumentReference ref = Firestore.instance
                        .collection('AccountsActivation')
                        .document(idController.text);
                    ref.get().then((data){
                      if(data.exists){
                        setState(() {
                          loadData = true;
                          userIdFromFirebase=data.data["userid"];
                          mobileIdFromFirebase=data.data["deviceid"];
                          print(userIdFromFirebase);
                          print(mobileIdFromFirebase);

                        });
                      }else{
                        flushBar(context, false,
                            massage: "تاكد من ادخال رقم يحتاج تفعيل", sec: 60);
                      }
                    });


                  }
                }),
            loadData == false
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white30,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text(userIdFromFirebase),
                                Spacer(),
                                Text("userId"),

                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(mobileIdFromFirebase),
                              Spacer(),
                              Text("phone id"),

                            ],
                          ),
                          SizedBox(height: 20,),
                          MaterialButton(

                              height: 30,minWidth: 70,  child: Text(
                            "activate",
                            style: TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                              color: Colors.green,
                              onPressed: () {
                                Firestore.instance
                                    .collection("UsersID")
                                    .document(idController.text)
                                    .updateData({
                                  "registeredPhone": mobileIdFromFirebase,
                                }).then((val){
                                  print("activated");
                                  flushBar(context, true,
                                      massage: "تم نفعيل الحساب", sec: 60);

                                  Firestore.instance
                                      .collection("AccountsActivation")
                                      .document(idController.text).delete();
                                  setState(() {
                                    idController.text=" ";
                                    loadData = false;
                                  });
                                });


                              }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[

                                MaterialButton(height: 30,minWidth: 70,
                                    child: Text(
                                      "stop",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    color: Colors.yellow,
                                    onPressed: () {
                                      Firestore.instance
                                          .collection("UsersID")
                                          .document(idController.text)
                                          .updateData({
                                        "registeredPhone": "empty",
                                      }).then((val){
                                        print("activated");
                                        flushBar(context, true,
                                            massage: "تم ايقاف الحساب", sec: 60);
                                        Firestore.instance
                                            .collection("AccountsActivation")
                                            .document(idController.text).delete();
                                        setState(() {
                                          loadData = false;
                                        });
                                      });


                                    }),
                                MaterialButton(height:30,minWidth: 70,
                                    child: Text(
                                      "block",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    color: Colors.red,
                                    onPressed: () {
                                      Firestore.instance
                                          .collection("UsersID")
                                          .document(idController.text)
                                          .updateData({
                                        "registeredPhone": "block",
                                      }).then((val){
                                        print("activated");
                                        flushBar(context, true,
                                            massage: "تم عمل بلوك للحساب", sec: 60);
                                        Firestore.instance
                                            .collection("AccountsActivation")
                                            .document(idController.text).delete();
                                        setState(() {
                                          idController.text=" ";
                                          loadData=false;
                                        });
                                      });


                                    })
                              ],
                            ),
                          ),
                          Text("ستوب تعليق مؤقت للحساب , المستخدم لن يتمكن المستخدم من الدخول + بامكانه ارسال طلب تفعيل "),
                          Text("بلوك  لن يتمكن المستخدم من الدخول + لن يتمكن من طلب تفعيل  ")

                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

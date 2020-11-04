import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var data;

  @override
  void initState() {
    getData();
  }

  getData() async {
    final DocumentReference document =
        ////1//t1
        Firestore.instance
            .collection("Quizes")
            .document('1')
            .collection('test1')
            .document('t1');

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      print(data);
      setState(() {
        data = snapshot.data;
        print(data);
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: data == null
            ? Text('loading..........')
            : ListView.builder(
                itemCount: data['QuestionsNumbers'],
                itemBuilder: (cx, index) {
                  return q(data,index);
                },
              ),
      ),
    );
  }


}
class q extends StatefulWidget {
  var data ,index;

  q(this.data, this.index);

  @override
  _qState createState() => _qState();
}

class _qState extends State<q> {
  int gv;
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.data['question${widget.index + 1}']),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.data['answers${widget.index + 1}'].length,
            itemBuilder: (answercx, x) {

              return RadioListTile(
                value: widget.index,
                groupValue: gv,
                onChanged: (ind) => setState(() => gv = ind),
                title: Text("Number ${widget.index}"),
              );
            })
      ],
    ),);
  }
}

/*
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data['answers${index + 1}'].length,
                          itemBuilder: (answercx, x) {

                            return Answers(x,x,data["answers${index + 1}"][x]);
                          }),
                      Divider()*/
class NewWidget extends StatelessWidget {
   NewWidget({
    Key key,
    @required this.data,
    @required this.index,
  }) : super(key: key);

  var data;
//  final int groupValue;
  final int index;
  int groupValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data['question${index + 1}']),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data['answers${index + 1}'].length,
            itemBuilder: (answercx, x) {

              return Answers(x,x,data["answers${index + 1}"][x]);
            }),
        Divider()
      ],
    );
  }
}

class Answers extends StatefulWidget {
  int groupValue ;
  var value ;
  String title;

  Answers(this.groupValue, this.value,this.title);

  @override
  _AnswersState createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      toggleable: true,
      activeColor: Colors.pink,
      //value: data['answers${index + 1}'],
      value: widget.value,
      groupValue: widget.groupValue,
      onChanged: (newValue) =>
          setState(() {
            widget.groupValue = newValue;
          } ),
      title: Text(widget.title),
    );
  }
}
class RadioListBuilder extends StatefulWidget {
  final int num;

  const RadioListBuilder({Key key, this.num}) : super(key: key);

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  int value;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(shrinkWrap: true,
      itemBuilder: (context, index) {
        return RadioListTile(
          value: index,
          groupValue: value,
          onChanged: (ind) => setState(() => value = ind),
          title: Text("Number $index"),
        );
      },
      itemCount: widget.num,
    );
  }
}


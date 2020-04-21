// To parse this JSON data, do
//
//     final modelExam = modelExamFromJson(jsonString);

import 'dart:convert';

ModelExam modelExamFromJson(String str) => ModelExam.fromJson(json.decode(str));

String modelExamToJson(ModelExam data) => json.encode(data.toJson());

class ModelExam {
  Data data;
  String message;
  String status;

  ModelExam({
    this.data,
    this.message,
    this.status,
  });

  factory ModelExam.fromJson(Map<String, dynamic> json) => ModelExam(
    data: Data.fromJson(json["data"]),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
    "status": status,
  };
}

class Data {
  int id;
  String title;
  String number;
  String timer;
  String fullMark;
  String mcqMark;
  String tfqMark;
  String minMark;
  String grade;
  List<McQuestion> mcQuestions;
  List<TfQuestion> tfQuestions;

  Data({
    this.id,
    this.title,
    this.number,
    this.timer,
    this.fullMark,
    this.mcqMark,
    this.tfqMark,
    this.minMark,
    this.grade,
    this.mcQuestions,
    this.tfQuestions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    number: json["number"],
    timer: json["timer"],
    fullMark: json["full_mark"],
    mcqMark: json["mcq_mark"],
    tfqMark: json["tfq_mark"],
    minMark: json["min_mark"],
    grade: json["grade"],
    mcQuestions: List<McQuestion>.from(json["mc_questions"].map((x) => McQuestion.fromJson(x))),
    tfQuestions: List<TfQuestion>.from(json["tf_questions"].map((x) => TfQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "number": number,
    "timer": timer,
    "full_mark": fullMark,
    "mcq_mark": mcqMark,
    "tfq_mark": tfqMark,
    "min_mark": minMark,
    "grade": grade,
    "mc_questions": List<dynamic>.from(mcQuestions.map((x) => x.toJson())),
    "tf_questions": List<dynamic>.from(tfQuestions.map((x) => x.toJson())),
  };
}

class McQuestion {
  int id;
  String question;
  String choiceA;
  String choiceB;
  String choiceC;
  String choiceD;
  String rightAnswer;
  dynamic fullMark;

  McQuestion({
    this.id,
    this.question,
    this.choiceA,
    this.choiceB,
    this.choiceC,
    this.choiceD,
    this.rightAnswer,
    this.fullMark,
  });

  factory McQuestion.fromJson(Map<String, dynamic> json) => McQuestion(
    id: json["id"],
    question: json["question"],
    choiceA: json["choice_a"],
    choiceB: json["choice_b"],
    choiceC: json["choice_c"],
    choiceD: json["choice_d"],
    rightAnswer: json["right_answer"],
    fullMark: json["full_mark"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "choice_a": choiceA,
    "choice_b": choiceB,
    "choice_c": choiceC,
    "choice_d": choiceD,
    "right_answer": rightAnswer,
    "full_mark": fullMark,
  };
}

class TfQuestion {
  int id;
  String question;
  String rightAnswer;
  dynamic fullMark;

  TfQuestion({
    this.id,
    this.question,
    this.rightAnswer,
    this.fullMark,
  });

  factory TfQuestion.fromJson(Map<String, dynamic> json) => TfQuestion(
    id: json["id"],
    question: json["question"],
    rightAnswer: json["right_answer"],
    fullMark: json["full_mark"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "right_answer": rightAnswer,
    "full_mark": fullMark,
  };
}

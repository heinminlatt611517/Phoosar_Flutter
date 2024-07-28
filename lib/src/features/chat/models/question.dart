import 'dart:convert';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  int status;
  String message;
  List<Datum> data;
  Map<String, String> answerTypeList;

  Question({
    required this.status,
    required this.message,
    required this.data,
    required this.answerTypeList,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    answerTypeList: Map.from(json["answer_type_list"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "answer_type_list": Map.from(answerTypeList).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Datum {
  int id;
  String question;
  int answerType;
  List<Answer> answers;

  Datum({
    required this.id,
    required this.question,
    required this.answerType,
    required this.answers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    question: json["question"],
    answerType: json["answer_type"],
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer_type": answerType,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };
}

class Answer {
  int id;
  int questionId;
  String answer;

  Answer({
    required this.id,
    required this.questionId,
    required this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json["id"],
    questionId: json["question_id"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_id": questionId,
    "answer": answer,
  };
}
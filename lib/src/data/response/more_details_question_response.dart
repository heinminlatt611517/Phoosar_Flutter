import 'dart:convert';

MoreDetailsQuestionResponse moreDetailsQuestionResponseFromJson(String str) => MoreDetailsQuestionResponse.fromJson(json.decode(str));

String moreDetailsQuestionResponseToJson(MoreDetailsQuestionResponse data) => json.encode(data.toJson());

class MoreDetailsQuestionResponse {
  int? status;
  String? message;
  List<QuestionAnswerData>? data;

  MoreDetailsQuestionResponse({
    this.status,
    this.message,
    this.data,
  });

  factory MoreDetailsQuestionResponse.fromJson(Map<String, dynamic> json) => MoreDetailsQuestionResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<QuestionAnswerData>.from(json["data"]!.map((x) => QuestionAnswerData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QuestionAnswerData {
  int? id;
  String? question;
  int? answerType;
  List<dynamic>? answers;

  QuestionAnswerData({
    this.id,
    this.question,
    this.answerType,
    this.answers,
  });

  factory QuestionAnswerData.fromJson(Map<String, dynamic> json) => QuestionAnswerData(
    id: json["id"],
    question: json["question"],
    answerType: json["answer_type"],
    answers: json["answers"] == null ? [] : List<dynamic>.from(json["answers"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer_type": answerType,
    "answers": answers == null ? [] : List<dynamic>.from(answers!.map((x) => x)),
  };
}

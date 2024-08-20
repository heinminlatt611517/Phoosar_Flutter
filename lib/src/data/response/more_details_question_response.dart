class MoreDetailsQuestionResponse {
  int? status;
  String? message;
  List<QuestionAnswerData>? data;

  MoreDetailsQuestionResponse({this.status, this.message, this.data});

  MoreDetailsQuestionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <QuestionAnswerData>[];
      json['data'].forEach((v) {
        data!.add(new QuestionAnswerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionAnswerData {
  int? id;
  String? question;
  String? answerText;
  int? paidStatus;

  QuestionAnswerData({this.id, this.question, this.answerText, this.paidStatus});

  QuestionAnswerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answerText = json['answer_text'];
    paidStatus = json['paid_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer_text'] = this.answerText;
    data['paid_status'] = this.paidStatus;
    return data;
  }
}

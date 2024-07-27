class QuestionSaveRequest {
  List<Questions>? questions;

  QuestionSaveRequest({this.questions});

  QuestionSaveRequest.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? id;
  String? answerId;
  String? answerText;

  Questions({this.id, this.answerId, this.answerText});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerId = json['answer_id'];
    answerText = json['answer_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer_id'] = this.answerId;
    data['answer_text'] = this.answerText;
    return data;
  }
}

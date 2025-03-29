class Question {
  final int? id, answer;
  final String? question;
  final List<String>? options;

  Question({this.id, this.question, this.answer, this.options});
}

const List sample_data = [
  {
    "id": 1,
    "question": "Flutter is an open-source UI software development kit created by ______",
    "options": ['Apple', 'Google', 'Facebook', 'Microsoft'],
    "answer_index": 1,
  },
  {
    "id": 2,
    "question": "When did Google release Flutter?",
    "options": ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
    "answer_index": 2,
  },
  {
    "id": 3,
    "question": "A memory location that holds a single letter or number is called a ______.",
    "options": ['Double', 'Int', 'Char', 'Word'],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "What command do you use to output data to the screen in C++?",
    "options": ['Cin', 'Count>>', 'Cout', 'Output>>'],
    "answer_index": 2,
  },
  {
    "id": 5,
    "question": "What is the main language used for Flutter app development?",
    "options": ['Java', 'Dart', 'C++', 'Swift'],
    "answer_index": 1,
  },
  {
    "id": 6,
    "question": "In which year was JavaScript created?",
    "options": ['1995', '2000', '1988', '1990'],
    "answer_index": 0,
  },
  {
    "id": 7,
    "question": "Which of the following is not a primary color in digital displays?",
    "options": ['Red', 'Green', 'Blue', 'Yellow'],
    "answer_index": 3,
  },
  {
    "id": 8,
    "question": "What does HTTP stand for?",
    "options": ['Hyper Transfer Text Protocol', 'HyperText Transfer Protocol', 'Hyper Task Text Protocol', 'HyperText Transaction Protocol'],
    "answer_index": 1,
  },
  {
    "id": 9,
    "question": "Which of these is the most common database used in Flutter apps?",
    "options": ['SQLite', 'MongoDB', 'Firebase', 'MySQL'],
    "answer_index": 0,
  },
  {
    "id": 10,
    "question": "Which of these is not a valid loop in C++?",
    "options": ['for', 'while', 'do-while', 'repeat'],
    "answer_index": 3,
  },
];

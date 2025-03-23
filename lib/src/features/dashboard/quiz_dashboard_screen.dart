import 'package:flutter/material.dart';

class QuizDashboardScreen extends StatefulWidget {
  @override
  _QuizDashboardScreenState createState() => _QuizDashboardScreenState();
}

class _QuizDashboardScreenState extends State<QuizDashboardScreen> {
  bool isQuestionAnswered = false;
  int currentQuestionIndex = 0;
  int score = 0;
  bool quizCompleted = false;

  final List<QuestionData> questions = [
    QuestionData(
      question: 'What is the capital of France?',
      options: ['Berlin', 'Madrid', 'Paris', 'Lisbon'],
      correctAnswer: 'Paris',
    ),
    QuestionData(
      question: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
      correctAnswer: '4',
    ),
    QuestionData(
      question: 'Who developed the theory of relativity?',
      options: ['Isaac Newton', 'Albert Einstein', 'Galileo Galilei', 'Nikola Tesla'],
      correctAnswer: 'Albert Einstein',
    ),
    QuestionData(
      question: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswer: 'Mars',
    ),
    QuestionData(
      question: 'What is the largest ocean on Earth?',
      options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      correctAnswer: 'Pacific',
    ),
    QuestionData(
      question: 'Who was the first president of the United States?',
      options: ['Abraham Lincoln', 'George Washington', 'Thomas Jefferson', 'John Adams'],
      correctAnswer: 'George Washington',
    ),
    QuestionData(
      question: 'What is the chemical symbol for water?',
      options: ['O2', 'H2O', 'CO2', 'HO2'],
      correctAnswer: 'H2O',
    ),
    QuestionData(
      question: 'Which country is the largest by area?',
      options: ['China', 'United States', 'Canada', 'Russia'],
      correctAnswer: 'Russia',
    ),
    QuestionData(
      question: 'What is the capital of Japan?',
      options: ['Seoul', 'Beijing', 'Tokyo', 'Kyoto'],
      correctAnswer: 'Tokyo',
    ),
    QuestionData(
      question: 'Which is the smallest planet in our solar system?',
      options: ['Mercury', 'Venus', 'Mars', 'Pluto'],
      correctAnswer: 'Mercury',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: quizCompleted
          ? _buildQuizCompletedScreen()
          : _buildQuestionScreen(),
    );
  }

  /// Build the quiz question screen
  Widget _buildQuestionScreen() {
    var currentQuestion = questions[currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentQuestion.question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ...currentQuestion.options.map(
                (option) => ElevatedButton(
              onPressed: isQuestionAnswered
                  ? null
                  : () {
                setState(() {
                  isQuestionAnswered = true;
                });
                _handleAnswer(option);
              },
              child: Text(option),
            ),
          ),
          SizedBox(height: 20),
          Text('Score: $score', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // Handle when user answers a question
  Future<void> _handleAnswer(String answer) async {
    var currentQuestion = questions[currentQuestionIndex];

    if (currentQuestion.correctAnswer == answer) {
      setState(() {
        score++;
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isQuestionAnswered = false; // Reset for the next question
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
  }

  // Show message when quiz is completed
  Widget _buildQuizCompletedScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Quiz Completed!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Your Score: $score/${questions.length}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                score = 0;
                currentQuestionIndex = 0;
                quizCompleted = false;
              });
            },
            child: Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}

class QuestionData {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionData({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

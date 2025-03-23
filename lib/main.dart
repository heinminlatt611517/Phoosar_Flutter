import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/env/env.dart';
import 'package:phoosar/firebase_options.dart';
import 'package:phoosar/src/fcm/fcm_service.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  final sharedPref = await SharedPreferences.getInstance();
  await settingsController.loadSettings();
  setPathUrlStrategy();
  registerErrorHandlers();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        name: "Phoosar App", options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  await Supabase.initialize(
    url: Env.supabaseBaseUrl,
    anonKey: Env.supabaseAnonDataKey,
  );

  FCMService().navigatorKey = navigatorKey;

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWith((ref) => sharedPref),
      ],
      child: MyApp(
        settingsController: settingsController,
        sharedPreferences: sharedPref,
        navigatorKey: navigatorKey,
      ),
    ),
  );
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Added to provide bounded constraints
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(details.toString()),
          ),
        ),
      ),
    );
  };
}

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission(); // Request permission when the app starts
  }

  // Requesting Notification Permission
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission granted for notifications.");
    } else {
      print("Permission denied for notifications.");
    }
  }

  // Function to open notification settings
  void openNotificationSettings() {
    //AppSettings.openNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Want to manage push notifications?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openNotificationSettings,
              child: Text('Go to Notification Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: EnterNameScreen(),
//     );
//   }
// }
//
//
// class EnterNameScreen extends StatefulWidget {
//   @override
//   _EnterNameScreenState createState() => _EnterNameScreenState();
// }
//
// class _EnterNameScreenState extends State<EnterNameScreen> {
//   TextEditingController _nameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             children: [
//               Image.asset(
//                 'assets/images/quiz.jpg',
//                 height: 80,
//               ),
//               SizedBox(height: 100),
//               Text('Please enter your name',style: TextStyle(fontSize: 18),),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Your Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_nameController.text.isNotEmpty) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => QuizDashboardScreen(userName: _nameController.text),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text('Start'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class QuizDashboardScreen extends StatefulWidget {
//   final String userName;
//   QuizDashboardScreen({required this.userName});
//
//   @override
//   _QuizDashboardScreenState createState() => _QuizDashboardScreenState();
// }
//
// class _QuizDashboardScreenState extends State<QuizDashboardScreen> {
//   bool isQuestionAnswered = false;
//   int currentQuestionIndex = 0;
//   int score = 0;
//   bool quizCompleted = false;
//   int timerSeconds = 30;
//   Timer? _timer;
//
//   int _selectedIndex = 0;
//
//   final List<QuestionData> knowledgeQuestions = [
//     QuestionData(
//       question: 'What is the capital of France?',
//       options: ['Berlin', 'Madrid', 'Paris', 'Lisbon'],
//       correctAnswer: 'Paris',
//     ),
//     QuestionData(
//       question: 'What is the largest continent?',
//       options: ['Africa', 'Asia', 'Europe', 'North America'],
//       correctAnswer: 'Asia',
//     ),
//     QuestionData(
//       question: 'Who painted the Mona Lisa?',
//       options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Claude Monet'],
//       correctAnswer: 'Leonardo da Vinci',
//     ),
//     QuestionData(
//       question: 'What is the smallest country in the world?',
//       options: ['Vatican City', 'Monaco', 'San Marino', 'Liechtenstein'],
//       correctAnswer: 'Vatican City',
//     ),
//     QuestionData(
//       question: 'What is the largest ocean on Earth?',
//       options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
//       correctAnswer: 'Pacific Ocean',
//     ),
//     QuestionData(
//       question: 'Which planet is closest to the Sun?',
//       options: ['Earth', 'Mars', 'Mercury', 'Venus'],
//       correctAnswer: 'Mercury',
//     ),
//     QuestionData(
//       question: 'Which country is known as the Land of the Rising Sun?',
//       options: ['South Korea', 'Japan', 'China', 'Thailand'],
//       correctAnswer: 'Japan',
//     ),
//     QuestionData(
//       question: 'What is the longest river in the world?',
//       options: ['Amazon River', 'Nile River', 'Yangtze River', 'Mississippi River'],
//       correctAnswer: 'Amazon River',
//     ),
//     QuestionData(
//       question: 'What is the national flower of the United States?',
//       options: ['Rose', 'Tulip', 'Sunflower', 'Lily'],
//       correctAnswer: 'Rose',
//     ),
//     QuestionData(
//       question: 'Which is the largest desert in the world?',
//       options: ['Sahara Desert', 'Arabian Desert', 'Karakum Desert', 'Antarctic Desert'],
//       correctAnswer: 'Antarctic Desert',
//     ),
//     QuestionData(
//       question: 'What is the primary language spoken in Brazil?',
//       options: ['Spanish', 'Portuguese', 'French', 'English'],
//       correctAnswer: 'Portuguese',
//     ),
//     QuestionData(
//       question: 'Which is the longest mountain range in the world?',
//       options: ['Himalayas', 'Andes', 'Rocky Mountains', 'Alps'],
//       correctAnswer: 'Andes',
//     ),
//     QuestionData(
//       question: 'Which country invented paper?',
//       options: ['Egypt', 'China', 'Greece', 'India'],
//       correctAnswer: 'China',
//     ),
//     QuestionData(
//       question: 'Which city is known as the Big Apple?',
//       options: ['Los Angeles', 'New York City', 'Chicago', 'San Francisco'],
//       correctAnswer: 'New York City',
//     ),
//     QuestionData(
//       question: 'Which element has the chemical symbol O?',
//       options: ['Oxygen', 'Osmium', 'Oganesson', 'Ozone'],
//       correctAnswer: 'Oxygen',
//     ),
//   ];
//
//
//   final List<QuestionData> programmingQuestions = [
//     QuestionData(
//       question: 'Which language is used for web development?',
//       options: ['Java', 'C++', 'Python', 'JavaScript'],
//       correctAnswer: 'JavaScript',
//     ),
//     QuestionData(
//       question: 'What is the main purpose of the `main()` function in C?',
//       options: ['Starting point of the program', 'Defines variables', 'Handles memory allocation', 'None of the above'],
//       correctAnswer: 'Starting point of the program',
//     ),
//     QuestionData(
//       question: 'Which of the following is an object-oriented programming language?',
//       options: ['Python', 'C', 'Fortran', 'Assembly'],
//       correctAnswer: 'Python',
//     ),
//     QuestionData(
//       question: 'What does HTML stand for?',
//       options: ['Hyper Text Markup Language', 'Hyperlinks and Text Markup Language', 'Home Tool Markup Language', 'High-level Text Markup Language'],
//       correctAnswer: 'Hyper Text Markup Language',
//     ),
//     QuestionData(
//       question: 'Which language is primarily used for Android development?',
//       options: ['Swift', 'Java', 'C#', 'Kotlin'],
//       correctAnswer: 'Java',
//     ),
//     QuestionData(
//       question: 'What is the correct syntax to create a function in JavaScript?',
//       options: ['function myFunction()', 'def myFunction()', 'func myFunction()', 'function: myFunction()'],
//       correctAnswer: 'function myFunction()',
//     ),
//     QuestionData(
//       question: 'Which of these is NOT a valid Python data type?',
//       options: ['int', 'float', 'decimal', 'str'],
//       correctAnswer: 'decimal',
//     ),
//     QuestionData(
//       question: 'In C++, what is the correct way to declare a constant variable?',
//       options: ['int x = 10;', 'const int x = 10;', 'constant int x = 10;', 'int const x = 10;'],
//       correctAnswer: 'const int x = 10;',
//     ),
//     QuestionData(
//       question: 'Which of the following is used to style a webpage?',
//       options: ['HTML', 'CSS', 'JavaScript', 'PHP'],
//       correctAnswer: 'CSS',
//     ),
//     QuestionData(
//       question: 'Which operator is used for comparison in most programming languages?',
//       options: ['==', '=', '===', '!='],
//       correctAnswer: '==',
//     ),
//     QuestionData(
//       question: 'Which of the following is a loop in JavaScript?',
//       options: ['for', 'while', 'do-while', 'All of the above'],
//       correctAnswer: 'All of the above',
//     ),
//     QuestionData(
//       question: 'Which of the following data structures uses a LIFO approach?',
//       options: ['Queue', 'Stack', 'Array', 'Linked List'],
//       correctAnswer: 'Stack',
//     ),
//     QuestionData(
//       question: 'In Python, how do you comment a single line?',
//       options: ['# comment', '/* comment */', '/* comment', 'comment//'],
//       correctAnswer: '# comment',
//     ),
//     QuestionData(
//       question: 'What does SQL stand for?',
//       options: ['Structured Query Language', 'Simple Query Language', 'Structured Query Log', 'Sequential Query Language'],
//       correctAnswer: 'Structured Query Language',
//     ),
//     QuestionData(
//       question: 'What is the purpose of the "break" statement in loops?',
//       options: ['Exit the loop', 'Skip the current iteration', 'Restart the loop', 'Pause the loop'],
//       correctAnswer: 'Exit the loop',
//     ),
//   ];
//
//   final List<QuestionData> scienceQuestions = [
//     QuestionData(
//       question: 'What is the chemical symbol for water?',
//       options: ['O2', 'H2O', 'CO2', 'HO2'],
//       correctAnswer: 'H2O',
//     ),
//     QuestionData(
//       question: 'Who developed the theory of relativity?',
//       options: ['Isaac Newton', 'Albert Einstein', 'Galileo Galilei', 'Nikola Tesla'],
//       correctAnswer: 'Albert Einstein',
//     ),
//     QuestionData(
//       question: 'What is the atomic number of Carbon?',
//       options: ['6', '8', '12', '14'],
//       correctAnswer: '6',
//     ),
//     QuestionData(
//       question: 'Which planet is known as the Red Planet?',
//       options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
//       correctAnswer: 'Mars',
//     ),
//     QuestionData(
//       question: 'What is the powerhouse of the cell?',
//       options: ['Nucleus', 'Mitochondria', 'Endoplasmic Reticulum', 'Golgi Apparatus'],
//       correctAnswer: 'Mitochondria',
//     ),
//     QuestionData(
//       question: 'What is the most common element in the Earth\'s crust?',
//       options: ['Iron', 'Oxygen', 'Silicon', 'Aluminum'],
//       correctAnswer: 'Oxygen',
//     ),
//     QuestionData(
//       question: 'Which gas do plants absorb from the atmosphere during photosynthesis?',
//       options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
//       correctAnswer: 'Carbon Dioxide',
//     ),
//     QuestionData(
//       question: 'What type of bond holds two hydrogen atoms together in a molecule of hydrogen gas?',
//       options: ['Ionic Bond', 'Covalent Bond', 'Hydrogen Bond', 'Metallic Bond'],
//       correctAnswer: 'Covalent Bond',
//     ),
//     QuestionData(
//       question: 'How many bones are in the adult human body?',
//       options: ['206', '210', '213', '215'],
//       correctAnswer: '206',
//     ),
//     QuestionData(
//       question: 'What is the chemical symbol for gold?',
//       options: ['Ag', 'Au', 'Pb', 'Fe'],
//       correctAnswer: 'Au',
//     ),
//     QuestionData(
//       question: 'What is the primary source of energy for the Earth?',
//       options: ['Moon', 'Sun', 'Stars', 'Tidal Energy'],
//       correctAnswer: 'Sun',
//     ),
//     QuestionData(
//       question: 'What is the most abundant gas in Earth\'s atmosphere?',
//       options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
//       correctAnswer: 'Nitrogen',
//     ),
//     QuestionData(
//       question: 'Which organ in the human body is primarily responsible for pumping blood?',
//       options: ['Brain', 'Lungs', 'Heart', 'Liver'],
//       correctAnswer: 'Heart',
//     ),
//     QuestionData(
//       question: 'What is the speed of light in a vacuum?',
//       options: ['300,000 km/s', '150,000 km/s', '500,000 km/s', '150,000 miles/s'],
//       correctAnswer: '300,000 km/s',
//     ),
//     QuestionData(
//       question: 'What is the force that pulls objects toward Earth?',
//       options: ['Magnetism', 'Electrostatic Force', 'Gravity', 'Friction'],
//       correctAnswer: 'Gravity',
//     ),
//   ];
//
//
//   // Get current question list based on selected category
//   List<QuestionData> get currentCategoryQuestions {
//     switch (_selectedIndex) {
//       case 0:
//         return knowledgeQuestions;
//       case 1:
//         return programmingQuestions;
//       case 2:
//         return scienceQuestions;
//       default:
//         return knowledgeQuestions;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }
//
//   // Start the countdown timer
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (timerSeconds > 0) {
//         setState(() {
//           timerSeconds--;
//         });
//       } else {
//         _handleAnswer('');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome ${widget.userName}'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.leaderboard,color: Colors.blueAccent,),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LeaderboardScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: quizCompleted ? _buildQuizCompletedScreen() : _buildQuestionScreen(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//             score = 0;
//             currentQuestionIndex = 0;
//             quizCompleted = false;
//             isQuestionAnswered = false;
//             timerSeconds = 30;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Knowledge'),
//           BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Programming'),
//           BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
//         ],
//       ),
//     );
//   }
//
//   // Build the quiz question screen
//   Widget _buildQuestionScreen() {
//     var currentQuestion = currentCategoryQuestions[currentQuestionIndex];
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             currentQuestion.question,
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           ...currentQuestion.options.map(
//                 (option) => ElevatedButton(
//               onPressed: isQuestionAnswered
//                   ? null
//                   : () {
//                 setState(() {
//                   isQuestionAnswered = true;
//                 });
//                 _handleAnswer(option);
//               },
//               child: Text(option),
//             ),
//           ),
//           SizedBox(height: 20),
//           Text('Score: $score', style: TextStyle(fontSize: 18)),
//           SizedBox(height: 10),
//           Text('Time Left: $timerSeconds', style: TextStyle(fontSize: 18)),
//         ],
//       ),
//     );
//   }
//
//   // Handle when user answers a question
//   Future<void> _handleAnswer(String answer) async {
//     var currentQuestion = currentCategoryQuestions[currentQuestionIndex];
//
//     if (currentQuestion.correctAnswer == answer) {
//       setState(() {
//         score++;
//       });
//     }
//
//     if (currentQuestionIndex < currentCategoryQuestions.length - 1) {
//       setState(() {
//         currentQuestionIndex++;
//         isQuestionAnswered = false; // Reset for the next question
//         timerSeconds = 30; // Reset timer for next question
//       });
//     } else {
//       setState(() {
//         quizCompleted = true;
//       });
//     }
//   }
//
//   // Show message when quiz is completed
//   Widget _buildQuizCompletedScreen() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Center(
//         child: Column(
//           children: [
//             Text(
//               textAlign: TextAlign.center,
//               'Quiz Completed!',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               textAlign: TextAlign.center,
//               'Your Score: $score/${currentCategoryQuestions.length}',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _restartQuiz,
//               child: Text('Restart Quiz'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Restart the quiz by resetting necessary states
//   void _restartQuiz() {
//     setState(() {
//       score = 0;
//       currentQuestionIndex = 0;
//       quizCompleted = false;
//       isQuestionAnswered = false;
//       timerSeconds = 30;
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }
//
// class QuestionData {
//   final String question;
//   final List<String> options;
//   final String correctAnswer;
//
//   QuestionData({
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });
// }
//
//
//
// class LeaderboardScreen extends StatefulWidget {
//   @override
//   _LeaderboardScreenState createState() => _LeaderboardScreenState();
// }
//
// class _LeaderboardScreenState extends State<LeaderboardScreen> {
//   final List<Map<String, dynamic>> leaderboard = [
//     {'name': 'Aung Myin', 'score': '8/10'},
//     {'name': 'Ko Ko', 'score': '9/10'},
//     {'name': 'Aye Thida', 'score': '7/10'},
//     {'name': 'Chan Myae', 'score': '6/10'},
//     {'name': 'Ko Aung', 'score': '5/10'},
//     {'name': 'Hitn Lin', 'score': '4/10'},
//     {'name': 'Lin Ko Ko', 'score': '3/10'},
//     {'name': 'Mya Thida', 'score': '2/10'},
//   ];
//
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _simulateLoading();
//   }
//
//   // Simulate the loading process
//   void _simulateLoading() {
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Separate top 3 users and others
//     final topUsers = leaderboard.take(3).toList();
//     final otherUsers = leaderboard.skip(3).toList();
//
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(title: Text('Leaderboard')),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(), // Show loading spinner
//       )
//           : Column(
//         children: [
//           // Header view with Row for top 3 users
//           Container(
//             height: 200,
//             padding: EdgeInsets.all(16),
//             color: Colors.blueAccent,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 for (int i = 0; i < topUsers.length; i++)
//                   Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundImage: NetworkImage(
//                             'https://www.w3schools.com/w3images/avatar2.png'), // Default user image
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         topUsers[i]['name'],
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text('Score: ${topUsers[i]['score']}'),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//
//           // List view for the rest of the users
//           Expanded(
//             child: ListView.builder(
//               itemCount: otherUsers.length,
//               itemBuilder: (context, index) {
//                 final user = otherUsers[index];
//                 return Container(
//                   margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
//                   padding: EdgeInsets.symmetric(vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           'https://www.w3schools.com/w3images/avatar2.png'), // Default user image
//                     ),
//                     title: Text(user['name']),
//                     trailing: Text('Score: ${user['score']}'),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//

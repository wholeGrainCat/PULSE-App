import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student/pages/RL_sidePages/anxiety.dart';
import 'package:student/pages/RL_sidePages/depression.dart';
import 'package:student/pages/RL_sidePages/self-care.dart';
import 'package:student/pages/RL_sidePages/stress.dart';
import 'package:student/pages/forgot_password.dart';
import 'package:student/pages/mood_diary.dart';
import 'package:student/pages/login.dart';
import 'package:student/pages/mood_done_check_in.dart';
import 'package:student/pages/mood_tracker.dart';
import 'package:student/pages/mood_calendar.dart';
import 'package:student/pages/resource_library.dart';
import 'package:student/pages/self_help_tools.dart';
import 'package:student/pages/student_dashboard.dart';
import 'package:student/onboarding/onboardingscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Uri _url = Uri.parse('https://flutter.dev');
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAnkMJToiEBeR3ph3Yi2KaL3wrAS_c-HKw",
            authDomain: "pulse-student.firebaseapp.com",
            projectId: "pulse-student",
            storageBucket: "pulse-student.firebasestorage.app",
            messagingSenderId: "346012969160",
            appId: "1:346012969160:web:1403a7cd4e80450c545dfd"));
  } else {
    await Firebase.initializeApp();
    // await SharedPreferences.getInstance();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PULSE",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(), // Set OnboardingPage as the first page
      routes: {
        '/login': (context) => LoginPage(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        '/studentdashboard': (context) => StudentDashboard(),
        '/moodtracker': (context) => MoodTrackerPage(),
        '/mooddonecheckin': (context) => MoodDoneCheckIn(),
        '/mooddiary': (context) => DiaryPage(),
        '/moodcalendar': (context) => MoodCalendarPage(),
        '/resource': (context) => ResourceLibraryPage(),
        '/stress': (context) => Stress(),
        '/depression': (context) => Depression(),
        '/selfcare': (context) => SelfCare(),
        '/anxiety': (context) => Anxiety(),
        '/selfhelptools': (context) => SelfHelpTools(),
      },
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student/pages/RL_sidePages/anxiety.dart';
import 'package:student/pages/RL_sidePages/depression.dart';
import 'package:student/pages/RL_sidePages/self-care.dart';
import 'package:student/pages/RL_sidePages/stress.dart';
import 'package:student/pages/forgot_password.dart';
import 'package:student/pages/mood_diary.dart';
import 'package:student/pages/login.dart';
import 'package:student/pages/mood_tracker.dart';
import 'package:student/pages/mood_calendar.dart';
import 'package:student/pages/reset_password.dart';
import 'package:student/pages/resource_library.dart';
import 'package:student/pages/self_help_tools.dart';
import 'package:student/pages/student_dashboard.dart';
import 'package:student/onboarding/onboardingscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';

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
      // home: MoodTrackerPage(),
      // home: StudentDashboard(),
      // home: ResourcePage(),
      home: const OnboardingScreen(), // Set OnboardingPage as the first page
      routes: {
        '/login': (context) => const LoginPage(),
        '/forgotpassword': (context) => const ForgotPasswordPage(),
        '/resetpassword': (context) => const ResetPasswordPage(),
        '/studentdashboard': (context) => const StudentDashboard(),
        '/moodtracker': (context) => const MoodTrackerPage(),
        '/mooddiary': (context) => const DiaryPage(),
        '/moodcalendar': (context) => const MoodCalendarPage(),
        '/resource': (context) => const ResourceLibraryPage(),
        '/stress': (context) => const Stress(),
        '/depression': (context) => const Depression(),
        '/selfcare': (context) => const SelfCare(),
        '/anxiety': (context) => const Anxiety(),
        '/selfhelptools': (context) => const SelfHelpTools(),
      },
    );
  }
}

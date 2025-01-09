import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student/Admin/pages/admin_profile_page.dart';
import 'package:student/Admin/pages/appointment_page.dart';
import 'package:student/chat/admin_home_page.dart';
import 'package:student/chat/chat_home_page.dart';
import 'package:student/Student/resources/anxiety.dart';
import 'package:student/Student/resources/depression.dart';
import 'package:student/Student/resources/self-care.dart';
import 'package:student/Student/resources/stress.dart';
import 'package:student/Student/forgot_password.dart';
import 'package:student/Student/logout.dart';
import 'package:student/Student/mood/mood_diary.dart';
import 'package:student/Student/login.dart';
import 'package:student/Student/mood/mood_done_check_in.dart';
import 'package:student/Student/mood/mood_tracker.dart';
import 'package:student/Student/mood/mood_calendar.dart';
import 'package:student/Student/profile/profile_screen.dart';
import 'package:student/Student/resources/resource_library.dart';
import 'package:student/Student/self_help_tools.dart';
import 'package:student/Student/student_dashboard.dart';
import 'package:student/user_role_selection.dart';
import 'package:student/onboarding/onboardingscreen.dart';
import 'package:student/Student/appoinment/appoinment_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:student/Admin/login.dart';
import 'package:student/Admin/admin_dashboard.dart';
import 'package:student/Admin/edit_resource_library.dart';
import 'package:student/Admin/pages/selfhelp_tools.dart';
//import 'package:student/pages/cloud_messageing.dart'; // Import your CloudMessaging class
//import 'package:shared_preferences/shared_preferences.dart';

final Uri _url = Uri.parse('https://flutter.dev');
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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

  // Initialize notifications and get token
  /*CloudMessage cloudMessage = CloudMessage();
  await cloudMessage.initNotifications();*/

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
        '/onboarding': (context) => const Onboarding(),
        '/login': (context) => const LoginPage(),
        '/forgotpassword': (context) => const ForgotPasswordPage(),
        '/studentdashboard': (context) => const StudentDashboard(),
        '/moodtracker': (context) => const MoodTrackerPage(),
        '/mooddonecheckin': (context) => const MoodDoneCheckIn(),
        '/mooddiary': (context) => const DiaryPage(),
        '/moodcalendar': (context) => const MoodCalendarPage(),
        '/resource': (context) => const ResourceLibraryPage(),
        '/stress': (context) => const Stress(),
        '/depression': (context) => const Depression(),
        '/selfcare': (context) => const SelfCare(),
        '/anxiety': (context) => const Anxiety(),
        '/selfhelptools': (context) => const SelfHelpTools(),
        '/appointments': (context) => const AppointmentScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatHomePage(),
        '/logout': (context) => const LogoutPage(),
        //Admin
        '/adminlogin': (context) => const AdminLoginPage(),
        '/admindashboard': (context) => const AdminDashboard(),
        '/adminprofile': (context) => const AdminProfilePage(),
        '/adminappointment': (context) => const AdminAppointmentPage(),
        '/adminchat': (context) => const AdminHomePage(),
        '/adminresource': (context) => const EditResourceLibraryPage(),
        '/adminselfhelptools': (context) => const SelfhelpToolsPage(),
      },
    );
  }
}

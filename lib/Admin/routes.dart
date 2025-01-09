import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile_screen.dart';
import 'appointment_screen.dart';
import 'onboarding.dart';
import 'login.dart';

class Routes {
  // Named routes
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String resource = '/resource';
  static const String appointment = '/appointment';
  static const String login = '/login';

  // Replace the class name to the real one when compiling
  // Map of routes to screen widgets
  static Map<String, WidgetBuilder> get routes {
    return {
      onboarding: (context) => Onboarding(),
      dashboard: (context) => Dashboard(),
      profile: (context) => ProfileScreen(),
      //chat: (context) => ChatScreen(),
      //resource: (context) => ResourceScreen(),
      appointment: (context) => AppointmentScreen(),
      login: (context) => LoginPage()
    };
  }
}

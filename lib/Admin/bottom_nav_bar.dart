import 'package:flutter/material.dart';
import 'routes.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF613EEA),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        // Navigate to the corresponding screen
        String route;
        switch (index) {
          case 0:
            route = Routes.resource;
            break;
          case 1:
            route = Routes.appointment;
            break;
          case 2:
            route = Routes.dashboard;
            break;
          case 3:
            route = Routes.chat;
            break;
          case 4:
            route = Routes.profile;
            break;
          default:
            route = Routes.dashboard;
        }
        Navigator.pushNamed(context, route); // Navigate to the selected route
        onTap(index); // Notify the parent widget of the new index
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Resource',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Appointment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

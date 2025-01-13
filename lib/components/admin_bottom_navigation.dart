import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';

class AdminBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white, // Background color for the navbar
      selectedItemColor:
          AppColors.pri_cyan, // Color for selected item icon and label
      unselectedItemColor:
          Colors.black.withOpacity(0.6), // Color for unselected icons
      type: BottomNavigationBarType.fixed, // Ensure the icons are evenly spaced
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety_rounded),
          label: 'Resources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.date_range_rounded),
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
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      selectedIconTheme: const IconThemeData(
        size: 40, // Increase the size of the selected icon
        color: AppColors.pri_cyan, // White color for selected icon
      ),
      unselectedIconTheme: const IconThemeData(
        size: 30, // Unselected icon size
        color: Colors.black, // Unselected icon color
      ),
      selectedLabelStyle: const TextStyle(
        color: AppColors.pri_cyan, // Label color for selected item
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        color:
            Colors.black.withOpacity(0.6), // Label color for unselected items
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8, // Adds a shadow for a floating effect
    );
  }
}

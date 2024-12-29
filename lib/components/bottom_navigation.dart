import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
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
      selectedItemColor: Colors.blue, // Color for selected item icon and label
      unselectedItemColor:
          Colors.black.withOpacity(0.6), // Color for unselected icons
      type: BottomNavigationBarType.fixed, // Ensure the icons are evenly spaced
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Resource',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mood),
          label: 'Mood',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Support',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedIconTheme: const IconThemeData(
        size: 40, // Increase the size of the selected icon
        color: Colors.blue, // White color for selected icon
      ),
      unselectedIconTheme: const IconThemeData(
        size: 30, // Unselected icon size
        color: Colors.black, // Unselected icon color
      ),
      selectedLabelStyle: const TextStyle(
        color: Colors.blue, // Label color for selected item
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

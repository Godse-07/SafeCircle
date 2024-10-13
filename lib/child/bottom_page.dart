import 'package:flutter/material.dart';
import 'package:woman_safety/child/bottom_screens/chat_page.dart';
import 'package:woman_safety/child/bottom_screens/contact_page.dart';
import 'package:woman_safety/child/bottom_screens/profile_page.dart';
import 'package:woman_safety/child/bottom_screens/review_page.dart';
import 'package:woman_safety/home_screen.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ContactPage(),
    ChatScreen(),
    ProfilePage(),
    ReviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.pink, // Color for selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_page), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: "Review"),
        ],
      ),
    );
  }
}

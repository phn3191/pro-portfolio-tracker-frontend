
import 'package:flutter/material.dart';
import 'screens/achievements_screen.dart';
import 'screens/trophies_screen.dart';
import 'screens/more_screen.dart';
import 'screens/add_achievement_screen.dart'; // ✅ Import thêm màn hình add

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievement Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F1FD), // tím nhạt
        useMaterial3: true,
      ),
      home: const MainNavigation(),
      routes: {
        '/add-achievement': (context) => const AddAchievementScreen(), // ✅ Route mới
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    AchievementsScreen(),
    TrophiesScreen(),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_outlined),
            label: 'Trophies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

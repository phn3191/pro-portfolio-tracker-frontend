import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const AchievementApp());
}

class AchievementApp extends StatelessWidget {
  const AchievementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievement Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

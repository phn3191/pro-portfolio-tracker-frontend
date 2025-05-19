import 'package:flutter/material.dart';
import 'screens/main_screen.dart';                 // ✅ Tập trung điều hướng tại đây
import 'screens/add_achievement_screen.dart';     // ✅ Route riêng để mở màn thêm thành tích

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Portfolio Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F1FD), // Pastel background
      ),
      home: const MainScreen(),     // ✅ Trang điều hướng chính (bottom nav)
      routes: {
        '/add-achievement': (context) => const AddAchievementScreen(),
      },
    );
  }
}

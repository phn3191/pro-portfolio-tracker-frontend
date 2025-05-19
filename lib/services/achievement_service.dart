import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/achievement.dart';

class AchievementService {
  static const String baseUrl = 'https://pro-portfolio-tracker.fly.dev';

  /// Fetch all achievements from the backend API
  Future<List<Achievement>> getAllAchievements() async {
    final response = await http.get(Uri.parse('$baseUrl/achievements'));

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);

      // Debug output for developers
      print('✅ API response: $jsonList');
      if (jsonList.isNotEmpty) {
        print('🎯 First impact: ${jsonList[0]['impact']}');
      }

      return jsonList.map((json) => Achievement.fromJson(json)).toList();
    } else {
      print('❌ API error: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to load achievements');
    }
  }

  /// Send a new achievement to the backend
  Future<void> addAchievement(Achievement achievement) async {
    final response = await http.post(
      Uri.parse('$baseUrl/achievements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(achievement.toJson()),
    );

    if (response.statusCode != 201) {
      print('❌ Failed to create achievement: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to create achievement');
    }
  }
}

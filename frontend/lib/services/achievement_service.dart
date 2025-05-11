import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/achievement.dart';

class AchievementService {
  static const String baseUrl = 'http://192.168.1.25:8080';

  Future<List<Achievement>> getAllAchievements() async {
    final response = await http.get(Uri.parse('$baseUrl/achievements'));

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Achievement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  Future<void> addAchievement(Achievement achievement) async {
    final response = await http.post(
      Uri.parse('$baseUrl/achievements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(achievement.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create achievement');
    }
  }
}

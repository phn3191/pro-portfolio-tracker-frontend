import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/achievement.dart';

class AchievementService {
  static const String baseUrl = 'https://pro-portfolio-tracker.fly.dev';

  Future<List<Achievement>> getAchievements() async {
    final response = await http.get(Uri.parse('$baseUrl/achievements'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Achievement.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  Future<Achievement> addAchievement(Achievement achievement) async {
    final response = await http.post(
      Uri.parse('$baseUrl/achievements'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(achievement.toJson()),
    );

    if (response.statusCode == 201) {
      return Achievement.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create achievement');
    }
  }

  Future<void> updateAchievement(int id, Achievement achievement) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/achievements/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(achievement.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update achievement');
    }
  }

  Future<void> deleteAchievement(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/achievements/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete achievement');
    }
  }
}

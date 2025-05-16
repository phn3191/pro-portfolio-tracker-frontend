import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/achievement.dart';

class AchievementService {
  static const String baseUrl = 'https://pro-portfolio-tracker.fly.dev';

  Future<List<Achievement>> getAllAchievements() async {
    final response = await http.get(Uri.parse('$baseUrl/achievements'));

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);

      // ✅ In ra console khi chạy Flutter Web (Chrome DevTools)
      print('✅ Dữ liệu từ API:');
      print(jsonList);

      if (jsonList.isNotEmpty) {
        print('🎯 Impact đầu tiên: ${jsonList[0]['impact']}');
      }

      return jsonList.map((json) => Achievement.fromJson(json)).toList();
    } else {
      print('❌ Lỗi khi gọi API: ${response.statusCode}');
      print('Body: ${response.body}');
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
      print('❌ Lỗi khi tạo achievement: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to create achievement');
    }
  }
}

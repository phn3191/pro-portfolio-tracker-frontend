import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TrophyService {
  static const String baseUrl = 'https://pro-portfolio-tracker.fly.dev'; // 🔁 Replace with your real API

  /// Upload trophy with optional file attachment
  Future<void> addTrophy({
    required String title,
    required String description,
    required String awardedDate,
    File? file,
  }) async {
    final uri = Uri.parse('$baseUrl/trophies');
    final request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = awardedDate;

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      final error = await response.stream.bytesToString();
      throw Exception('Failed to upload trophy: $error');
    }
  }

  /// Fetch all trophies from API
  Future<List<Map<String, dynamic>>> getAllTrophies() async {
    final response = await http.get(Uri.parse('$baseUrl/trophies'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load trophies');
    }
  }
}

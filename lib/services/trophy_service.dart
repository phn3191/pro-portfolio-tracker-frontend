import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trophy.dart';

class TrophyService {
  static const String baseUrl = 'https://pro-portfolio-tracker.fly.dev';

  Future<List<Trophy>> getTrophies() async {
    final response = await http.get(Uri.parse('$baseUrl/trophies'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Trophy.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trophies');
    }
  }

  Future<Trophy> addTrophy(Trophy trophy) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trophies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(trophy.toJson()),
    );

    if (response.statusCode == 201) {
      return Trophy.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create trophy');
    }
  }

  Future<void> updateTrophy(int id, Trophy trophy) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/trophies/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(trophy.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update trophy');
    }
  }

  Future<void> deleteTrophy(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/trophies/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete trophy');
    }
  }
}

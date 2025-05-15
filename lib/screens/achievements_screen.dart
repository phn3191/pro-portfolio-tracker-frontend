import 'package:flutter/material.dart';
import 'add_achievement_screen.dart';
import '../services/achievement_service.dart'; // Nhớ import service

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    _checkApiConnection();
  }

  void _checkApiConnection() async {
    try {
      final service = AchievementService();
      final achievements = await service.getAllAchievements();
      print('✅ Fetched ${achievements.length} achievements from API');
    } catch (e) {
      print('❌ API error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: search function
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          MonthSection(
            month: 'May',
            achievements: [
              AchievementItem(
                day: '1',
                description: 'Built UI for Tracker App',
                impact: 'Boosted team productivity',
                skill: 'Flutter, UI Design',
              ),
              AchievementItem(
                day: '3',
                description: 'Fixed login bug',
                impact: 'Reduced user complaints',
                skill: 'Debugging, Dart',
              ),
            ],
          ),
          SizedBox(height: 24),
          MonthSection(
            month: 'April',
            achievements: [
              AchievementItem(
                day: '20',
                description: 'Implemented File Upload',
                impact: 'Improved user functionality',
                skill: 'Backend, APIs',
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAchievementScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MonthSection extends StatelessWidget {
  final String month;
  final List<AchievementItem> achievements;

  const MonthSection({
    super.key,
    required this.month,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...achievements.map((a) => a),
      ],
    );
  }
}

class AchievementItem extends StatelessWidget {
  final String day;
  final String description;
  final String impact;
  final String skill;

  const AchievementItem({
    super.key,
    required this.day,
    required this.description,
    required this.impact,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Text(day),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Impact: $impact'),
                  Text('Skill: $skill'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

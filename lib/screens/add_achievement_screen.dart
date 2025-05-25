import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';

class AddAchievementScreen extends StatefulWidget {
  const AddAchievementScreen({super.key});

  @override
  _AddAchievementScreenState createState() => _AddAchievementScreenState();
}

class _AddAchievementScreenState extends State<AddAchievementScreen> {
  final _descriptionController = TextEditingController();
  final _impactController = TextEditingController();
  final _skillController = TextEditingController();
  final List<String> _skillTags = [];

  DateTime _selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveAchievement() async {
    final achievement = Achievement(
      description: _descriptionController.text.trim(),
      impact: _impactController.text.trim(),
      skillUsed: _skillTags.join(','),
      achievementDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );

    try {
      await AchievementService().addAchievement(achievement);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Achievement saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Achievement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _impactController,
              decoration: const InputDecoration(
                labelText: 'Impact',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skillController,
              decoration: const InputDecoration(
                labelText: 'Skill Used (type then comma to add)',
              ),
              onChanged: (value) {
                if (value.endsWith(',')) {
                  final tag = value.replaceAll(',', '').trim();
                  if (tag.isNotEmpty && !_skillTags.contains(tag)) {
                    setState(() {
                      _skillTags.add(tag);
                      _skillController.clear();
                    });
                  }
                }
              },
            ),
            Wrap(
              spacing: 8,
              children: _skillTags
                  .map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () => setState(() => _skillTags.remove(tag)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text('Achievement Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveAchievement,
              child: const Text('Save Achievement'),
            )
          ],
        ),
      ),
    );
  }
}

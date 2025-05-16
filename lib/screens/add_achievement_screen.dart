
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
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
  String? _pickedFileName;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _pickAttachment() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Pick image'),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null) {
                setState(() => _pickedFileName = result.files.single.name);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text('Pick file'),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles();
              if (result != null) {
                setState(() => _pickedFileName = result.files.single.name);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _saveAchievement() async {
    final achievement = Achievement(
      day: DateFormat('yyyy-MM-dd').format(_selectedDate),
      description: _descriptionController.text.trim(),
      impact: _impactController.text.trim(),
      skill: _skillTags.join(', '),
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _impactController,
              decoration: const InputDecoration(
                labelText: 'Impact',
                prefixIcon: Icon(Icons.flash_on),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skillController,
              decoration: const InputDecoration(
                labelText: 'Skill Used',
                prefixIcon: Icon(Icons.code),
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
                  child: Text(
                    'Achievement Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _pickedFileName != null ? 'File: $_pickedFileName' : 'Attach file (optional)',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickAttachment,
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveAchievement,
              icon: const Icon(Icons.save),
              label: const Text('Save Achievement'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';
import 'dart:io';

class AddAchievementScreen extends StatefulWidget {
  const AddAchievementScreen({super.key});

  @override
  State<AddAchievementScreen> createState() => _AddAchievementScreenState();
}

class _AddAchievementScreenState extends State<AddAchievementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _impactController = TextEditingController();
  String? _selectedSkill;
  DateTime? _selectedDate;
  File? _selectedFile;

  final AchievementService _service = AchievementService();
  bool _isSubmitting = false;

  List<String> skillOptions = ['Go', 'Flutter', 'SQL', 'Python', 'JavaScript'];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedSkill == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final achievement = Achievement(
      id: 0,
      description: _descriptionController.text,
      impact: _impactController.text,
      skillUsed: _selectedSkill!,
    );

    try {
      await _service.addAchievement(achievement);

      // TODO: Upload file logic nếu backend hỗ trợ

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _impactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Achievement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter description' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _impactController,
              decoration: const InputDecoration(
                labelText: 'Impact',
                prefixIcon: Icon(Icons.bolt),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter impact' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Skill Used',
                prefixIcon: Icon(Icons.code),
              ),
              value: _selectedSkill,
              items: skillOptions.map((skill) {
                return DropdownMenuItem<String>(
                  value: skill,
                  child: Text(skill),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSkill = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a skill' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedDate != null
                    ? 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                    : 'Choose achievement date',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedFile != null
                    ? 'Attached: ${_selectedFile!.path.split('/').last}'
                    : 'Attach file (optional)',
              ),
              trailing: const Icon(Icons.attach_file),
              onTap: _pickFile,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.save),
              label: const Text('Save Achievement'),
              onPressed: _isSubmitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

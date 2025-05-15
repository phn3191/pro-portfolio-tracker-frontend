import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

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
            leading: Icon(Icons.image),
            title: Text('Pick image'),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null) {
                setState(() => _pickedFileName = result.files.single.name);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text('Pick file'),
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
        title: null, // Không có tiêu đề
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
            ),

            // Impact
            SizedBox(height: 12),
            TextField(
              controller: _impactController,
              decoration: InputDecoration(
                labelText: 'Impact',
                prefixIcon: Icon(Icons.flash_on),
              ),
            ),

            // Skill Tags
            SizedBox(height: 12),
            TextField(
              controller: _skillController,
              decoration: InputDecoration(
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

            // Date Picker
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Achievement Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),

            // File Attachment
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _pickedFileName != null ? 'File: $_pickedFileName' : 'Attach file (optional)',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: _pickAttachment,
                ),
              ],
            ),

            // Save Button
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Save logic
              },
              icon: Icon(Icons.save),
              label: Text('Save Achievement'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}

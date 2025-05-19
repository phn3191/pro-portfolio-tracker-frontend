import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isScheduled = true;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
  Set<int> selectedDays = {3}; // Default: Wednesday

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildDaySelector() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final isSelected = selectedDays.contains(index);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedDays.remove(index);
              } else {
                selectedDays.add(index);
              }
            });
          },
          child: CircleAvatar(
            backgroundColor: isSelected ? Colors.black : Colors.transparent,
            child: Text(
              days[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }

  String _formatSelectedDays() {
    if (selectedDays.isEmpty) return 'no day';
    const fullNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return selectedDays.map((i) => fullNames[i]).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: isScheduled,
              onChanged: (value) {
                setState(() {
                  isScheduled = value;
                });
              },
              title: const Text('Schedule Reminder'),
              activeColor: Colors.green,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time', style: TextStyle(fontSize: 18)),
                TextButton(
                  onPressed: _pickTime,
                  child: Text(
                    selectedTime.format(context),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildDaySelector(),
            const SizedBox(height: 16),
            Text(
              'You will be reminded every ${_formatSelectedDays()} at ${selectedTime.format(context)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

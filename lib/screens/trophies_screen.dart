import 'package:flutter/material.dart';
import '../services/trophy_service.dart';

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({super.key});

  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
  late Future<List<Map<String, dynamic>>> _trophiesFuture;

  @override
  void initState() {
    super.initState();
    _trophiesFuture = TrophyService().getAllTrophies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trophies')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _trophiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trophies yet.'));
          }

          final trophies = snapshot.data!;
          return ListView.builder(
            itemCount: trophies.length,
            itemBuilder: (context, index) {
              final t = trophies[index];
              return ListTile(
                title: Text(t['title'] ?? ''),
                subtitle: Text(t['description'] ?? ''),
                trailing: Text(t['date'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}

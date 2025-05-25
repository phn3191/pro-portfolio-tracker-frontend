class Achievement {
  final DateTime achievementDate;
  final String description;
  final String impact;
  final List<String> skills; // tốt nhất nên là danh sách

  Achievement({
    required this.achievementDate,
    required this.description,
    required this.impact,
    required this.skills,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementDate: DateTime.parse(json['achievement_date']),
      description: json['description'] ?? '',
      impact: json['impact'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievement_date': achievementDate.toIso8601String().split('T').first,
      'description': description,
      'impact': impact,
      'skills': skills,
    };
  }
}

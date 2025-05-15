class Achievement {
  final String day;
  final String description;
  final String impact;
  final String skill;

  Achievement({
    required this.day,
    required this.description,
    required this.impact,
    required this.skill,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      day: json['day'] ?? '',
      description: json['description'] ?? '',
      impact: json['impact'] ?? '',
      skill: json['skill'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'description': description,
      'impact': impact,
      'skill': skill,
    };
  }
}

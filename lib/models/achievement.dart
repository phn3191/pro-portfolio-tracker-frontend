class Achievement {
  final int? id;
  final String description;
  final String impact;
  final String skillUsed;
  final String achievementDate;

  Achievement({
    this.id,
    required this.description,
    required this.impact,
    required this.skillUsed,
    required this.achievementDate,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      description: json['description'],
      impact: json['impact'],
      skillUsed: json['skill_used'],
      achievementDate: json['achievement_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'impact': impact,
      'skill_used': skillUsed,
      'achievement_date': achievementDate,
    };
  }
}

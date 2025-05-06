class Achievement {
  final int id;
  final String description;
  final String impact;
  final String skillUsed;

  Achievement({
    required this.id,
    required this.description,
    required this.impact,
    required this.skillUsed,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      description: json['description'],
      impact: json['impact'],
      skillUsed: json['skill_used'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'impact': impact,
      'skill_used': skillUsed,
    };
  }
}

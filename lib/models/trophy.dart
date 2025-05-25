class Trophy {
  final int? id;
  final String description;
  final String trophyDate;

  Trophy({
    this.id,
    required this.description,
    required this.trophyDate,
  });

  factory Trophy.fromJson(Map<String, dynamic> json) {
    return Trophy(
      id: json['id'],
      description: json['description'],
      trophyDate: json['trophy_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'trophy_date': trophyDate,
    };
  }
}

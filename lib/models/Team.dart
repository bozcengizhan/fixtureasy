class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    final teamData = json['team'];
    return Team(
      id: teamData['id'],
      name: teamData['name'],
      logo: teamData['logo'],
    );
  }

  // SharedPreferences'a kaydetmek için Map'e çevirme
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'logo': logo};
  }
}

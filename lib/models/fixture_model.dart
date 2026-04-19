class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(id: json['id'], name: json['name'], logo: json['logo']);
  }
}

class Fixture {
  final Team homeTeam;
  final Team awayTeam;
  final String status;

  Fixture({
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      homeTeam: Team.fromJson(json['teams']['home']),
      awayTeam: Team.fromJson(json['teams']['away']),
      status: json['fixture']['status']['short'],
    );
  }
}

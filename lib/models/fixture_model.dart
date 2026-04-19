class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Bilinmeyen Takım',
      logo: json['logo'] ?? '',
    );
  }
}

class Fixture {
  final Team homeTeam;
  final Team awayTeam;
  final String status;
  final DateTime date; // <--- KRİTİK EKLEME

  Fixture({
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    required this.date, // <--- KRİTİK EKLEME
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      homeTeam: Team.fromJson(json['teams']['home']),
      awayTeam: Team.fromJson(json['teams']['away']),
      status: json['fixture']['status']['short'],
      // API'den gelen "2026-04-19T21:00:00+00:00" formatını DateTime'a çeviriyoruz
      date: DateTime.parse(json['fixture']['date']),
    );
  }
}

class Fixture {
  final DateTime date;
  final String homeTeam;
  final String homeLogo;
  final String awayTeam;
  final String awayLogo;
  final String venue;

  Fixture({
    required this.date,
    required this.homeTeam,
    required this.homeLogo,
    required this.awayTeam,
    required this.awayLogo,
    required this.venue,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      date: DateTime.parse(json['fixture']['date']),
      homeTeam: json['teams']['home']['name'],
      homeLogo: json['teams']['home']['logo'],
      awayTeam: json['teams']['away']['name'],
      awayLogo: json['teams']['away']['logo'],
      venue: json['fixture']['venue']['name'] ?? 'Bilinmiyor',
    );
  }
}

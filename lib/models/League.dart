class League {
  final int id;
  final String name;
  final String logo;

  League({required this.id, required this.name, required this.logo});

  factory League.fromJson(Map<String, dynamic> json) {
    final leagueData = json['league'];
    return League(
      id: leagueData['id'],
      name: leagueData['name'],
      logo: leagueData['logo'],
    );
  }
}

class TheSportsEvent {
  final String idEvent;
  final String strEvent;
  final String strHomeTeam;
  final String strAwayTeam;
  final String? intHomeScore;
  final String? intAwayScore;
  final String dateEvent;
  final String? strTime;
  final String? strThumb;
  final String? strStatus;

  TheSportsEvent({
    required this.idEvent,
    required this.strEvent,
    required this.strHomeTeam,
    required this.strAwayTeam,
    this.intHomeScore,
    this.intAwayScore,
    required this.dateEvent,
    this.strTime,
    this.strThumb,
    this.strStatus,
  });

  // JSON verisini Flutter nesnesine dönüştüren fabrika metodumuz
  factory TheSportsEvent.fromJson(Map<String, dynamic> json) {
    return TheSportsEvent(
      idEvent: json['idEvent'] ?? '',
      strEvent: json['strEvent'] ?? '',
      strHomeTeam: json['strHomeTeam'] ?? 'Bilinmiyor',
      strAwayTeam: json['strAwayTeam'] ?? 'Bilinmiyor',
      intHomeScore: json['intHomeScore'],
      intAwayScore: json['intAwayScore'],
      dateEvent: json['dateEvent'] ?? '',
      strTime: json['strTime'],
      strThumb: json['strThumb'],
      strStatus: json['strStatus'],
    );
  }
}

class TheSportsEvent {
  final String idEvent;
  final String strEvent; // Örn: "Arsenal vs Chelsea"
  final String strHomeTeam;
  final String strAwayTeam;
  final String? intHomeScore;
  final String? intAwayScore;
  final String dateEvent; // Örn: "2026-04-19"
  final String? strTime;
  final String? strThumb; // Maçın görseli (varsa)
  final String? strStatus; // Maçın durumu

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

  factory TheSportsEvent.fromJson(Map<String, dynamic> json) {
    return TheSportsEvent(
      idEvent: json['idEvent'] ?? '',
      strEvent: json['strEvent'] ?? '',
      strHomeTeam: json['strHomeTeam'] ?? 'Bilinmiyor',
      strAwayTeam: json['strAwayTeam'] ?? 'Bilinmiyor',
      intHomeScore: json['intHomeScore'], // Null gelebilir (oynanmamış maç)
      intAwayScore: json['intAwayScore'],
      dateEvent: json['dateEvent'] ?? '',
      strTime: json['strTime'],
      strThumb: json['strThumb'],
      strStatus: json['strStatus'],
    );
  }
}

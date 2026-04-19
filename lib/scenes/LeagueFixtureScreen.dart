import 'package:flutter/material.dart';
import '../services/football_service.dart';

class LeagueFixtureScreen extends StatefulWidget {
  final int leagueId;
  final String leagueName;

  const LeagueFixtureScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  @override
  State<LeagueFixtureScreen> createState() => _LeagueFixtureScreenState();
}

class _LeagueFixtureScreenState extends State<LeagueFixtureScreen> {
  final FootballService _service = FootballService();
  List fixtures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeagueFixtures();
  }

  Future<void> _fetchLeagueFixtures() async {
    try {
      final now = DateTime.now();

      // Lig ID ve 2026 sezonuna göre fikstür çekiyoruz
      final response = await _service.getDio().get(
        '/fixtures',
        queryParameters: {'league': widget.leagueId, 'season': '2025'},
      );

      List allFixtures = response.data['response'];

      // Filtreleme: Sadece bugünden (19 Nisan 2026) sonraki maçlar
      final futureFixtures = allFixtures.where((f) {
        DateTime matchDate = DateTime.parse(f['fixture']['date']);
        return matchDate.isAfter(now);
      }).toList();

      // Tarihe göre sıralama (en yakın maç en üstte)
      futureFixtures.sort(
        (a, b) => DateTime.parse(
          a['fixture']['date'],
        ).compareTo(DateTime.parse(b['fixture']['date'])),
      );

      setState(() {
        fixtures = futureFixtures;
        isLoading = false;
      });
    } catch (e) {
      print("Lig fikstürü çekilirken hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.leagueName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fixtures.isEmpty
          ? const Center(
              child: Text("Bu lig için 2026'da planlanmış maç bulunamadı."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: fixtures.length,
              itemBuilder: (context, index) {
                final f = fixtures[index];
                final homeTeam = f['teams']['home'];
                final awayTeam = f['teams']['away'];
                final date = DateTime.parse(f['fixture']['date']).toLocal();

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Ev Sahibi
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(
                                homeTeam['logo'],
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                homeTeam['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        // Tarih ve Saat
                        Column(
                          children: [
                            Text(
                              "${date.day}/${date.month}/${date.year}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                            const Text(
                              "VS",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),

                        // Deplasman
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(
                                awayTeam['logo'],
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                awayTeam['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/football_service.dart';

class NationalTeamFixtureScreen extends StatefulWidget {
  final String countryName;
  const NationalTeamFixtureScreen({super.key, required this.countryName});

  @override
  State<NationalTeamFixtureScreen> createState() =>
      _NationalTeamFixtureScreenState();
}

class _NationalTeamFixtureScreenState extends State<NationalTeamFixtureScreen> {
  final FootballService _service = FootballService();
  List fixtures = [];
  bool isLoading = true;
  String? teamName;

  @override
  void initState() {
    super.initState();
    _loadNationalTeamData();
  }

  Future<void> _loadNationalTeamData() async {
    try {
      final dio = _service.getDio();
      final now = DateTime.now();

      // 1. ADIM: Ülke ismiyle o ülkenin milli takımının ID'sini buluyoruz
      final teamRes = await dio.get(
        '/teams',
        queryParameters: {'country': widget.countryName},
      );

      final List teams = teamRes.data['response'];

      // Listeden 'national: true' olan tek takımı (Milli Takım) ayıklıyoruz
      final nationalTeam = teams.firstWhere(
        (t) => t['team']['national'] == true,
        orElse: () => null,
      );

      if (nationalTeam != null) {
        int teamId = nationalTeam['team']['id'];
        setState(() {
          teamName = nationalTeam['team']['name'];
        });

        // 2. ADIM: Bulduğumuz ID ile 2026 sezonu fikstürünü çekiyoruz
        final fixtureRes = await dio.get(
          '/fixtures',
          queryParameters: {'team': teamId, 'season': '2025'},
        );

        List allFixtures = fixtureRes.data['response'];

        // 3. ADIM: Filtreleme - Sadece bugünden sonraki maçlar
        final futureFixtures = allFixtures.where((f) {
          DateTime matchDate = DateTime.parse(f['fixture']['date']);
          return matchDate.isAfter(now);
        }).toList();

        // Tarihe göre sıralama
        futureFixtures.sort(
          (a, b) => DateTime.parse(
            a['fixture']['date'],
          ).compareTo(DateTime.parse(b['fixture']['date'])),
        );

        setState(() {
          fixtures = futureFixtures;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Milli takım verisi yüklenirken hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(teamName ?? widget.countryName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fixtures.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.countryName} için 2026'da planlanmış maç yok.",
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: fixtures.length,
              itemBuilder: (context, index) {
                final f = fixtures[index];
                final homeTeam = f['teams']['home'];
                final awayTeam = f['teams']['away'];
                final date = DateTime.parse(f['fixture']['date']).toLocal();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Ev Sahibi
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(
                                homeTeam['logo'],
                                width: 45,
                                height: 45,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                homeTeam['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Skor / VS Alanı
                        Column(
                          children: [
                            Text(
                              "${date.day}.${date.month}.${date.year}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "VS",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            Text(
                              "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
                                width: 45,
                                height: 45,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                awayTeam['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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

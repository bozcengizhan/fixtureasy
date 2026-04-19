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

      // 1. ADIM: Milli Takım ID'sini bul
      final teamRes = await dio.get(
        '/teams',
        queryParameters: {'country': widget.countryName},
      );

      final List teams = teamRes.data['response'];
      final nationalTeam = teams.firstWhere(
        (t) => t['team']['national'] == true,
        orElse: () => null,
      );

      if (nationalTeam != null) {
        int teamId = nationalTeam['team']['id'];
        setState(() {
          teamName = nationalTeam['team']['name'];
        });

        // 2. ADIM: 2025 veya 2024 sezonundaki TÜM maçları çek
        // Tarih filtresi (now) artık kullanılmıyor.
        var fixtureRes = await dio.get(
          '/fixtures',
          queryParameters: {'team': teamId, 'season': '2025'},
        );

        List allFixtures = fixtureRes.data['response'];

        // Eğer 2025 boşsa 2024'ü dene (Garantici yaklaşım)
        if (allFixtures.isEmpty) {
          fixtureRes = await dio.get(
            '/fixtures',
            queryParameters: {'team': teamId, 'season': '2024'},
          );
          allFixtures = fixtureRes.data['response'];
        }

        // 3. ADIM: Filtreleme YAPMIYORUZ.
        // Sadece gelen veriyi tarihe göre sıralıyoruz (Eskiden yeniye)
        allFixtures.sort(
          (a, b) => DateTime.parse(
            a['fixture']['date'],
          ).compareTo(DateTime.parse(b['fixture']['date'])),
        );

        setState(() {
          fixtures = allFixtures; // Gelen her şeyi listeye bastık
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Hata: $e");
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
          ? const Center(child: Text("Veri bulunamadı."))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: fixtures.length,
              itemBuilder: (context, index) {
                final f = fixtures[index];
                final homeTeam = f['teams']['home'];
                final awayTeam = f['teams']['away'];
                final date = DateTime.parse(f['fixture']['date']).toLocal();
                final status =
                    f['fixture']['status']['short']; // Maçın durumu (FT, NS vb.)

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Image.network(homeTeam['logo'], width: 40),
                    title: Text(
                      "${homeTeam['name']} - ${awayTeam['name']}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Column(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${date.day}.${date.month}.${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                        ),
                        Text(
                          "Durum: $status",
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    trailing: Image.network(awayTeam['logo'], width: 40),
                  ),
                );
              },
            ),
    );
  }
}

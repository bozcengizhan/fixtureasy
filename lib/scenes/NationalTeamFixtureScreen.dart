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
  bool isLoading = true;
  List fixtures = [];
  String? teamName;

  @override
  void initState() {
    super.initState();
    _loadNationalTeamData();
  }

  Future<void> _loadNationalTeamData() async {
    try {
      final dio = _service.getDio();
      final now = DateTime.now(); // Şu anki tarih (19 Nisan 2026)

      // 1. Ülke üzerinden takımı bul
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

        // 2. 2026 sezonu maçlarını çek
        final fixtureRes = await dio.get(
          '/fixtures',
          queryParameters: {'team': teamId, 'season': '2026'},
        );

        List allFixtures = fixtureRes.data['response'];

        // 3. Tarih ve Durum Filtrelemesi
        final futureFixtures = allFixtures.where((f) {
          // API'den gelen tarihi Dart DateTime nesnesine çeviriyoruz
          DateTime matchDate = DateTime.parse(f['fixture']['date']);
          String status = f['fixture']['status']['short'];

          // Maç tarihi bugünden sonraysa VE henüz başlamadıysa (NS) listeye al
          return matchDate.isAfter(now) && status == "NS";
        }).toList();

        // Maçları tarihe göre yakından uzağa sıralayalım
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
          ? const Center(child: Text("Fikstür bulunamadı."))
          : ListView.builder(
              itemCount: fixtures.length,
              itemBuilder: (context, index) {
                final f = fixtures[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(
                      f['teams']['home']['logo'],
                      width: 30,
                    ),
                    title: Text(
                      "${f['teams']['home']['name']} - ${f['teams']['away']['name']}",
                    ),
                    subtitle: Text(
                      f['fixture']['date'].toString().substring(0, 10),
                    ),
                    trailing: Image.network(
                      f['teams']['away']['logo'],
                      width: 30,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

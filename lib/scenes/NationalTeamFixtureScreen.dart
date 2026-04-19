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

      // 1. Önce ülkenin milli takımının ID'sini buluyoruz
      final teamRes = await dio.get(
        '/teams',
        queryParameters: {
          'name': widget.countryName,
          'country': widget.countryName,
        },
      );

      final teams = teamRes.data['response'];

      // Listeden milli takım olanı filtrele (national: true)
      final nationalTeam = teams.firstWhere(
        (t) => t['team']['national'] == true,
        orElse: () => null,
      );

      if (nationalTeam != null) {
        int teamId = nationalTeam['team']['id'];
        setState(() {
          teamName = nationalTeam['team']['name'];
        });

        // 2. Bulduğumuz ID ile fikstürü çekiyoruz (2026 sezonu örneği)
        final fixtureRes = await dio.get(
          '/fixtures',
          queryParameters: {
            'team': teamId,
            'next': 10, // Gelecek 10 maçı getir
          },
        );

        setState(() {
          fixtures = fixtureRes.data['response'];
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

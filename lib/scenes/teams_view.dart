import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/ApiService.dart';
import '../models/Team.dart';
import 'fixtures_view.dart'; // Son adımda oluşturacağız

class TeamsView extends StatefulWidget {
  final int leagueId;
  final String leagueName;

  const TeamsView({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  final ApiService _apiService = ApiService();
  late Future<List<Team>> _teamsFuture;

  @override
  void initState() {
    super.initState();
    // Artık .then kullanmaya gerek yok, servis direkt List<Team> döndürüyor
    _teamsFuture = _apiService.getTeams(widget.leagueId);
  }

  // Takım verilerini telefona kaydeden fonksiyon
  Future<void> _saveLastTeam(Team team) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastTeamId', team.id);
    await prefs.setString('lastTeamName', team.name);
    await prefs.setString('lastTeamLogo', team.logo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.leagueName),
        backgroundColor: Colors.green[800],
      ),
      body: FutureBuilder<List<Team>>(
        future: _teamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          final teams = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Yan yana 2 takım
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return InkWell(
                onTap: () async {
                  // 1. Takımı hafızaya kaydet
                  await _saveLastTeam(team);

                  // 2. Fikstür sayfasına git
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FixturesView(teamId: team.id, teamName: team.name),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CachedNetworkImage(
                            imageUrl: team.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/football_service.dart';
import 'NationalTeamFixtureScreen.dart';
import 'LeagueFixtureScreen.dart';

class SelectionScreen extends StatefulWidget {
  final String countryName;
  const SelectionScreen({super.key, required this.countryName});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final FootballService _service = FootballService();
  List leagues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
  }

  Future<void> _fetchLeagues() async {
    try {
      // Seçilen ülkeye ait tüm ligleri çekiyoruz
      final response = await _service.getDio().get(
        '/leagues',
        queryParameters: {'country': widget.countryName},
      );

      setState(() {
        leagues = response.data['response'];
        isLoading = false;
      });
    } catch (e) {
      print("Ligler yüklenirken hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.countryName), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                // --- 1. MİLLİ TAKIM BÖLÜMÜ ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "ULUSAL TAKIM",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.star, color: Colors.white),
                    ),
                    title: Text("${widget.countryName} Milli Takımı"),
                    subtitle: const Text("Fikstür ve maç detayları"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NationalTeamFixtureScreen(
                            countryName: widget.countryName,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // --- 2. YEREL LİGLER BÖLÜMÜ ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "YEREL LİGLER",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Ligler listesini mapleyerek ekliyoruz
                ...leagues.map((item) {
                  final league = item['league'];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Image.network(
                        league['logo'],
                        width: 35,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.emoji_events),
                      ),
                      title: Text(league['name']),
                      trailing: const Icon(Icons.chevron_right, size: 18),
                      onTap: () {
                        // Lig fikstür sayfasına yönlendirme (League ID ile)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeagueFixtureScreen(
                              leagueId: league['id'],
                              leagueName: league['name'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}

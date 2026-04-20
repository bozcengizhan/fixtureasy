import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/ApiService.dart';
import '../models/League.dart';
import 'teams_view.dart'; // Bir sonraki adımda oluşturacağız

class LeaguesView extends StatefulWidget {
  final String countryName;

  const LeaguesView({super.key, required this.countryName});

  @override
  State<LeaguesView> createState() => _LeaguesViewState();
}

class _LeaguesViewState extends State<LeaguesView> {
  final ApiService _apiService = ApiService();
  late Future<List<League>> _leaguesFuture;

  @override
  void initState() {
    super.initState();
    _leaguesFuture = _apiService.getLeagues(widget.countryName); // Hata kalmaz!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.countryName} Ligleri"),
        backgroundColor: Colors.green[800],
      ),
      body: FutureBuilder<List<League>>(
        future: _leaguesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Ligler yüklenirken hata: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Bu ülke için lig bulunamadı."));
          }

          final leagues = snapshot.data!;

          return ListView.builder(
            itemCount: leagues.length,
            itemBuilder: (context, index) {
              final league = leagues[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: league.logo,
                    width: 50,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.emoji_events),
                  ),
                  title: Text(
                    league.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Seçilen ligin ID'sini takımlar sayfasına gönderiyoruz
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamsView(
                          leagueId: league.id,
                          leagueName: league.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

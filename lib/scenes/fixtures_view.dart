import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/ApiService.dart';
import '../models/Fixture.dart';

class FixturesView extends StatefulWidget {
  final int teamId;
  final String teamName;

  const FixturesView({super.key, required this.teamId, required this.teamName});

  @override
  State<FixturesView> createState() => _FixturesViewState();
}

class _FixturesViewState extends State<FixturesView> {
  final ApiService _apiService = ApiService();
  late Future<List<Fixture>> _fixturesFuture;

  @override
  void initState() {
    super.initState();
    _fixturesFuture = _apiService.getFixtures(widget.teamId).then((data) {
      // 'data' içindeki her bir öğeyi (item) Map<String, dynamic> olarak cast ediyoruz
      return data
          .map<Fixture>(
            (dynamic item) => Fixture.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.teamName} Fikstürü"),
        backgroundColor: Colors.green[800],
      ),
      body: FutureBuilder<List<Fixture>>(
        future: _fixturesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Fikstür yüklenemedi: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Veri boş geldi. Team ID: ${widget.teamId}"),
            );
          }

          final fixtures = snapshot.data!;

          return ListView.builder(
            itemCount: fixtures.length,
            itemBuilder: (context, index) {
              final fixture = fixtures[index];
              // Tarihi formatlıyoruz: Örn: 20 Apr, 21:00
              String formattedDate = DateFormat(
                'dd MMM yyyy, HH:mm',
              ).format(fixture.date);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Ev Sahibi
                          Expanded(
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: fixture.homeLogo,
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  fixture.homeTeam,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "VS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          // Deplasman
                          Expanded(
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: fixture.awayLogo,
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  fixture.awayTeam,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            fixture.venue,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
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

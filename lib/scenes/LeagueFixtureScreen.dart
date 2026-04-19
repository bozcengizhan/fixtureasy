import 'package:flutter/material.dart';
import '../services/football_service.dart';
import '../models/fixture_model.dart'; // Modelinin bulunduğu yolu kontrol et

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
  List<Fixture> fixtures = []; // Artık model listesi kullanıyoruz
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSmartFixtures();
  }

  Future<void> _fetchSmartFixtures() async {
    try {
      final dio = _service.getDio();

      print(
        "--- SORGULANIYOR: ${widget.leagueName} (ID: ${widget.leagueId}) ---",
      );

      // 1. ADIM: Mevcut Sezonu (2025) Dene
      // Not: Nisan 2026'da olduğumuz için Avrupa liglerinin aktif sezonu 2025'tir.
      var response = await dio.get(
        'fixtures',
        queryParameters: {'league': widget.leagueId, 'season': 2025},
      );

      List data = response.data['response'] ?? [];

      // 2. ADIM: Eğer 2025 tamamen boşsa (Yeni başlamış bir lig olabilir), 2026'yı dene
      if (data.isEmpty) {
        print("2025 boş çıktı, 2026 sezonu deneniyor...");
        response = await dio.get(
          'fixtures',
          queryParameters: {'league': widget.leagueId, 'season': 2026},
        );
        data = response.data['response'] ?? [];
      }

      // 3. ADIM: Hala boşsa 2024 (Arşiv) verisine bak
      if (data.isEmpty) {
        print("2026 da boş çıktı, son çare 2024 deneniyor...");
        response = await dio.get(
          'fixtures',
          queryParameters: {'league': widget.leagueId, 'season': 2024},
        );
        data = response.data['response'] ?? [];
      }

      print("TOPLAM VERİ: ${data.length}");

      if (data.isNotEmpty) {
        try {
          List<Fixture> allFixtures = data
              .map((json) => Fixture.fromJson(json))
              .toList();

          // --- AKILLI SIRALAMA ---
          // Gelecek maçları (NS) en üste, geçmiş maçları (FT) altına dizer.
          // Gelecek maçlar kendi içinde en yakın tarihten uzağa sıralanır.
          allFixtures.sort((a, b) {
            if (a.status == "NS" && b.status == "NS") {
              return a.date.compareTo(b.date); // Yakındaki gelecek maç en üstte
            } else if (a.status == "FT" && b.status == "FT") {
              return b.date.compareTo(a.date); // Yeni bitmiş maç üstte
            }
            return (a.status == "NS") ? -1 : 1; // NS durumundakileri öne al
          });

          setState(() {
            fixtures = allFixtures;
            isLoading = false;
          });
        } catch (e) {
          print("MODEL DÖNÜŞTÜRME HATASI: $e");
          setState(() => isLoading = false);
        }
      } else {
        print("HİÇBİR SEZONDA VERİ BULUNAMADI.");
        setState(() {
          fixtures = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("SORGULAMA HATASI: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.leagueName),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fixtures.isEmpty
          ? const Center(child: Text("Maç verisi bulunamadı."))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: fixtures.length,
              itemBuilder: (context, index) {
                final f = fixtures[index];
                final date = f.date.toLocal();

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        // Ev Sahibi
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Image.network(
                                f.homeTeam.logo,
                                width: 45,
                                height: 45,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                f.homeTeam.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Orta Alan (Tarih + VS/Skor + Durum)
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                "${date.day}.${date.month}.${date.year}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                f.status == "NS"
                                    ? "VS"
                                    : "BİTTİ", // Skor istersen buraya ekleyebiliriz
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: f.status == "NS"
                                      ? Colors.blue
                                      : Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: f.status == "NS"
                                      ? Colors.green[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  f.status,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Deplasman
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Image.network(
                                f.awayTeam.logo,
                                width: 45,
                                height: 45,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                f.awayTeam.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
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

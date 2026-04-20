import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'countries_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? lastTeamName;
  String? lastTeamLogo;
  int? lastTeamId;

  @override
  void initState() {
    super.initState();
    _loadLastTeam(); // Sayfa açıldığında son bakılan takımı getir
  }

  // Hafızadaki takımı getiren fonksiyon
  Future<void> _loadLastTeam() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastTeamName = prefs.getString('lastTeamName');
      lastTeamLogo = prefs.getString('lastTeamLogo');
      lastTeamId = prefs.getInt('lastTeamId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Futbol Fikstür"),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Ülke Seçim Butonu
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CountriesView(),
                  ),
                ).then(
                  (_) => _loadLastTeam(),
                ); // Geri dönüldüğünde son takımı güncelle
              },
              icon: const Icon(Icons.public),
              label: const Text("Ülke Seçimi Yap"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // 2. Son Bakılan Takım Bölümü
            const Text(
              "Son Bakılan Takım",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            lastTeamId != null
                ? _buildLastTeamCard() // Takım varsa kartı göster
                : _buildNoDataCard(), // Takım yoksa uyarıyı göster
          ],
        ),
      ),
    );
  }

  // Son bakılan takım kartı tasarımı
  Widget _buildLastTeamCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(lastTeamLogo!, width: 40),
        title: Text(
          lastTeamName!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text("Fikstüre gitmek için tıkla"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Burada direkt Fikstür sayfasına yönlendirme yapılacak
          print("Takım ID: $lastTeamId fikstürüne gidiliyor...");
        },
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          "Henüz bir takıma bakmadınız.",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

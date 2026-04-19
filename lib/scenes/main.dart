import 'package:fixtureasy/scenes/LeaguesScreen.dart';
import 'package:flutter/material.dart';

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
      home: const FootballHomeScreen(),
    );
  }
}

class FootballHomeScreen extends StatelessWidget {
  const FootballHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FixturEasy',
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Başlıklar için sola yasladık
          children: [
            const SizedBox(height: 10),

            // ANA NAVİGASYON KARTI
            _buildMainNavigationCard(context),

            const SizedBox(height: 40),

            // BÖLÜM BAŞLIĞI
            const Row(
              children: [
                Icon(Icons.history, size: 20, color: Colors.grey),
                SizedBox(width: 10),
                Text(
                  "SON BAKILAN TAKIMLAR",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // TAKIM LİSTESİ (TheSportsDB ile entegre edilecek alan)
            Expanded(
              child: ListView.builder(
                itemCount:
                    3, // Şimdilik statik, ileride Local DB veya API'den gelecek
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildRecentTeamCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Üstteki Büyük Buton Yapısı
  Widget _buildMainNavigationCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeaguesScreen()),
        );
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.2),
              Colors.blueAccent.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 40, color: Colors.blueAccent),
            SizedBox(width: 20),
            Text(
              "TÜM LİGLERİ KEŞFET",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Takım Kartı Tasarımı
  Widget _buildRecentTeamCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          // İleride buraya Image.network(teamBadgeUrl) gelecek
          child: const Icon(Icons.shield, color: Colors.blueAccent, size: 28),
        ),
        title: Text(
          "Takım ${index + 1}", // Örn: Galatasaray, Real Madrid
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: const Text(
          "Lig Bilgisi", // Örn: Trendyol Süper Lig
          style: TextStyle(fontSize: 12, color: Colors.white38),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () {
          // Burası ileride TeamDetailScreen'e gidecek
        },
      ),
    );
  }
}

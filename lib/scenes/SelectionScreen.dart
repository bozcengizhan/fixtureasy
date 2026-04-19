import 'package:fixtureasy/scenes/LeagueFixtureScreen%20.dart';
import 'package:flutter/material.dart';
// Dosya ismindeki boşluğu temizledik, projedeki dosya adıyla tam eşleşmeli
import 'LeagueFixtureScreen .dart';

class SelectionScreen extends StatelessWidget {
  final int leagueId;
  final String leagueName;

  const SelectionScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(leagueName),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent, // Daha modern bir görünüm için
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lig İkonu ve Başlık
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 15),
            Text(
              leagueName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),

            // SEÇENEK 1: FİKSTÜR VE SONUÇLAR
            _buildOptionCard(
              title: "Fikstür ve Sonuçlar",
              subtitle: "Maç sonuçları ve gelecek program",
              icon: Icons.calendar_month,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeagueFixtureScreen(
                      leagueId: leagueId,
                      leagueName: leagueName,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // SEÇENEK 2: PUAN DURUMU
            _buildOptionCard(
              title: "Puan Durumu",
              subtitle: "Lig sıralaması ve detaylı tablo",
              icon: Icons.format_list_numbered,
              color: Colors.orangeAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Puan durumu yakında eklenecek!"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Ortak Tasarım Kartı - Parametrelerden BuildContext'i kaldırdık çünkü StatelessWidget içinde gerek yok
  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:fixtureasy/scenes/CountriesScreen.dart';
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
      appBar: AppBar(title: const Text('FixturEasy'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ÜST BUTON (Sadece ÜLKELER)
            // Center içine alarak tek butonu ortaladık
            Center(
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.8, // Ekranın %80'i kadar genişlik
                child: _buildMenuButton(context, "ÜLKELER", Icons.public),
              ),
            ),

            const SizedBox(height: 30),

            // BÖLÜM BAŞLIĞI
            const Text(
              "SON BAKILAN TAKIMLAR",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),

            // LİSTE
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white10,
                        child: Icon(Icons.shield, color: Colors.white54),
                      ),
                      title: Text("Takım Adı ${index + 1}"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white24,
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        // BURASI ÖNEMLİ: title ne gelirse gelsin CountriesScreen'e gitsin
        // veya 'ÜLKELER' olarak kontrol edelim
        if (title == "ÜLKELER") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CountriesScreen()),
          );
        }
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueAccent,
            width: 2,
          ), // Daha belirgin yaptık
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

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
      theme: ThemeData.dark(), // Taslağına uygun koyu tema
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Başlığı sola yaslamak için
          children: [
            // ÜST BUTONLAR (Ülke ve Ligler)
            Row(
              children: [
                Expanded(
                  child: _buildMenuButton(
                    context,
                    "ÜLKE TAKIMLARI",
                    Icons.flag,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMenuButton(context, "LİGLER", Icons.list),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // BÖLÜM BAŞLIĞI
            const Text(
              "SON BAKILAN TAKIMLAR",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),

            // LİSTE (Artık tam genişlikte ve dikey akıyor)
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                physics: const BouncingScrollPhysics(), // Daha yumuşak kaydırma
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.05,
                      ), // Hafif bir dolgu rengi
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white10,
                        child: Icon(
                          Icons.shield,
                          color: Colors.white54,
                        ), // Takım logosu yerine geçici icon
                      ),
                      title: Text("Takım Adı ${index + 1}"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white24,
                      ),
                      onTap: () {
                        // Takıma tıklanınca ne olacağını buraya yazacağız
                      },
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

  // Menü butonu widget'ı aynı kalabilir
  Widget _buildMenuButton(BuildContext context, String title, IconData icon) {
    return InkWell(
      // Tıklanma efekti ekledik
      onTap: () => print("$title tıklandı"),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

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
      appBar: AppBar(title: const Text('UYGULAMA ADI'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ÜST BUTONLAR
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

            // SON BAKILANLAR BÖLÜMÜ
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DİKEY YAZI
                  const RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      "SON BAKILAN TAKIMLAR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // LİSTE
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text("Takım Adı")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon) {
    return Container(
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

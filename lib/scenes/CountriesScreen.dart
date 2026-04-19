import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/football_service.dart';
import 'SelectionScreen.dart'; // Yeni eklediğimiz yönlendirme sayfası

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final FootballService _service = FootballService();
  List countries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final response = await _service.getDio().get('/countries');
      setState(() {
        countries = response.data['response'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ülke Seçin"),
      ), // Başlığı genel bir isim yaptık
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                final String? flagUrl = country['flag'];

                return ListTile(
                  leading: SizedBox(
                    width: 40,
                    child: (flagUrl != null && flagUrl.endsWith('.svg'))
                        ? SvgPicture.network(
                            flagUrl,
                            placeholderBuilder: (context) =>
                                const Icon(Icons.flag),
                          )
                        : (flagUrl != null
                              ? Image.network(
                                  flagUrl,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.flag),
                                )
                              : const Icon(Icons.flag)),
                  ),
                  title: Text(country['name']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // ARTIK BURASI SELECTION SCREEN'E GİDİYOR
                    _goToSelection(context, country['name']);
                  },
                );
              },
            ),
    );
  }

  // Fonksiyonun ismini ve hedefini değiştirdik
  void _goToSelection(BuildContext context, String countryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionScreen(countryName: countryName),
      ),
    );
  }
}

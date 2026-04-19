import 'package:fixtureasy/scenes/NationalTeamFixtureScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG desteği için
import '../services/football_service.dart';

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
      appBar: AppBar(title: const Text("Milli Takım Seçin")),
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
                    // Tıklanan ülkenin ismini bir sonraki sayfaya gönderiyoruz
                    _goToNationalTeamFixture(context, country['name']);
                  },
                );
              },
            ),
    );
  }

  void _goToNationalTeamFixture(BuildContext context, String countryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NationalTeamFixtureScreen(countryName: countryName),
      ),
    );
  }
}

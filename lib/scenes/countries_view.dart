import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Proje ismine göre import yolunu kontrol et (fixtureasy senin proje adın ise doğru)
import 'package:fixtureasy/services/ApiService.dart';
import 'package:fixtureasy/models/Country.dart';
import 'leagues_view.dart';

class CountriesView extends StatefulWidget {
  const CountriesView({super.key});

  @override
  State<CountriesView> createState() => _CountriesViewState();
}

class _CountriesViewState extends State<CountriesView> {
  final ApiService _apiService = ApiService();
  late Future<List<Country>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    // Veriyi çekiyoruz.
    // Eğer ApiService içindeki getCountries List<Country> döndürüyorsa direkt atama yapabilirsin.
    _countriesFuture = _apiService.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ülke Seçin"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Country>>(
        future: _countriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata oluştu: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // BURADAKİ HATALI "Child:" SİLİNDİ
            return const Center(child: Text("Ülke bulunamadı."));
          }

          final countries = snapshot.data!;

          return ListView.separated(
            itemCount: countries.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                leading: country.flag.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: country.flag,
                        width: 40,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.flag),
                      )
                    : const Icon(Icons.flag),
                title: Text(country.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LeaguesView(countryName: country.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

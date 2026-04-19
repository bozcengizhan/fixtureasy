import 'package:dio/dio.dart';

class TheSportsDBService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.thesportsdb.com/api/v2/json/123/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // --- BU KISMI EKLE ---
  // Tüm dünyadaki ligleri listeler (LeaguesScreen için)
  Future<List<dynamic>> getAllLeagues() async {
    try {
      final response = await _dio.get('all_leagues.php');
      return response.data['leagues'] ?? [];
    } catch (e) {
      print("Lig listesi çekilirken hata oluştu: $e");
      return [];
    }
  }
  // ---------------------

  Future<List<dynamic>> getLastResults(int leagueId) async {
    print("SORGULANAN LIG ID: $leagueId");
    try {
      final response = await _dio.get(
        'eventspastleague.php', // 'eventslast.php' yerine bunu dene
        queryParameters: {'id': leagueId.toString()},
      );
      // results yerine 'events' anahtarına da bakabilir
      return response.data['results'] ?? response.data['events'] ?? [];
    } catch (e) {
      print("Hata: $e");
      return [];
    }
  }

  // Gelecek maçları getiren fonksiyon
  Future<List<dynamic>> getNextEvents(int leagueId) async {
    try {
      final response = await _dio.get(
        'eventsnextleague.php', // Doğru endpoint: eventsnextleague.php
        queryParameters: {'id': leagueId.toString()}, // Burası leagueId olmalı!
      );
      return response.data['events'] ?? [];
    } catch (e) {
      print("Hata: $e");
      return [];
    }
  }

  Future<List<dynamic>> getLeaguesByCountry(String countryName) async {
    try {
      final response = await _dio.get(
        'search_all_leagues.php',
        queryParameters: {'c': countryName},
      );
      return response.data['countries'] ??
          []; // API burada 'countries' anahtarıyla döner
    } catch (e) {
      print("Ülke ligleri çekilirken hata: $e");
      return [];
    }
  }

  Dio getDio() => _dio;
}

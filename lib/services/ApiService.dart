import 'dart:convert';
import 'package:fixtureasy/models/Country.dart';
import 'package:fixtureasy/models/Fixture.dart';
import 'package:fixtureasy/models/League.dart';
import 'package:fixtureasy/models/Team.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _apiKey = "e1adc0a33313eba5901205c2588669a0";
  final String _baseUrl = "https://v3.football.api-sports.io";

  // API için gerekli header bilgileri
  Map<String, String> get _headers => {
    'x-rapidapi-key': _apiKey,
    'x-rapidapi-host': 'v3.football.api-sports.io',
  };

  // 1. Tüm Ülkeleri Getir
  // ApiService içinde örnek güncelleme:
  Future<List<Country>> getCountries() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/countries'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['response'];
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Hata');
    }
  }

  Future<List<League>> getLeagues(String countryName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/leagues?country=$countryName'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> list = data['response'];
      // Dönüşümü burada yapıp direkt listeyi gönderiyoruz
      return list.map((item) => League.fromJson(item)).toList();
    } else {
      throw Exception('Ligler yüklenemedi');
    }
  }

  Future<List<Team>> getTeams(int leagueId, {String season = "2024"}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/teams?league=$leagueId&season=$season'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> responseList = data['response'];
      // Dönüşümü burada yapıyoruz:
      return responseList.map((item) => Team.fromJson(item)).toList();
    } else {
      throw Exception('Takımlar yüklenemedi');
    }
  }

  Future<List<dynamic>> getFixtures(int teamId) async {
    // TEST 1: Gelecek maçlar yerine SON oynanan maçları çekmeyi deneyelim.
    // Eğer bu veri gelirse bağlantın ve API Key'in sağlam demektir.
    final response = await http.get(
      Uri.parse('$_baseUrl/fixtures?team=$teamId&last=5'),
      headers: _headers,
    );

    print("--- DEBUG BAŞLADI ---");
    print("URL: $_baseUrl/fixtures?team=$teamId&last=5");
    print("Gelen Yanıt: ${response.body}");
    print("--- DEBUG BİTTİ ---");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['response'];
    } else {
      throw Exception('Hata Kodu: ${response.statusCode}');
    }
  }
}

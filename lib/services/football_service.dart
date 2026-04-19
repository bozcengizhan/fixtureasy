import 'package:dio/dio.dart';

class TheSportsDBService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://www.thesportsdb.com/api/v1/json/3/', // '3' ücretsiz test keyidir
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Ligin son oynanan maçlarını getirir
  Future<List<dynamic>> getLastResults(int leagueId) async {
    try {
      final response = await _dio.get(
        'eventspastleague.php',
        queryParameters: {'id': leagueId},
      );
      return response.data['events'] ?? [];
    } catch (e) {
      print("TheSportsDB Hatası (Past): $e");
      return [];
    }
  }

  // Ligin gelecek maçlarını getirir
  Future<List<dynamic>> getNextEvents(int leagueId) async {
    try {
      final response = await _dio.get(
        'eventsnextleague.php',
        queryParameters: {'id': leagueId},
      );
      return response.data['events'] ?? [];
    } catch (e) {
      print("TheSportsDB Hatası (Next): $e");
      return [];
    }
  }

  Dio getDio() => _dio;
}

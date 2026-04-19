import 'package:dio/dio.dart';
import '../models/fixture_model.dart';

class FootballService {
  final Dio _dio = Dio(
    BaseOptions(
      // 1. URL'nin sonuna / ekledik
      baseUrl: 'https://v3.football.api-sports.io/',
      headers: {
        'x-apisports-key': 'e1adc0a33313eba5901205c2588669a0',
        'x-rapidapi-host': 'v3.football.api-sports.io',
      },
      // Zaman aşımı süreleri ekleyelim ki emülatör takılı kalmasın
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Mevcut getFixtures metodun (Ana ekranda kullanıyorsan)
  Future<List<dynamic>> getFixtures(String date) async {
    try {
      final response = await _dio.get(
        'fixtures', // Başındaki / işaretini sildik çünkü baseUrl'de var
        queryParameters: {'date': date},
      );

      // DEBUG: Gelen ham veriyi gör
      print("API RAW DATA: ${response.data}");

      if (response.data['errors'] != null &&
          response.data['errors'] is Map &&
          response.data['errors'].isNotEmpty) {
        print("API'DEN GELEN HATA: ${response.data['errors']}");
        return [];
      }

      if (response.statusCode == 200) {
        List data = response.data['response'];
        return data; // Model dönüşümünü ihtiyacına göre yaparsın
      }
      return [];
    } on DioException catch (e) {
      print("DIO HATASI: ${e.type} - ${e.message}");
      return [];
    }
  }

  Dio getDio() => _dio;
}

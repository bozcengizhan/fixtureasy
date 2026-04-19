import 'package:dio/dio.dart';
import '../models/fixture_model.dart';

class FootballService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://v3.football.api-sports.io',
      headers: {
        'x-apisports-key': 'e1adc0a33313eba5901205c2588669a0',
        'x-rapidapi-host': 'v3.football.api-sports.io',
      },
    ),
  );

  Future<List<Fixture>> getFixtures(String date) async {
    try {
      final response = await _dio.get(
        '/fixtures',
        queryParameters: {'date': date},
      );
      if (response.statusCode == 200) {
        List data = response.data['response'];
        return data.map((json) => Fixture.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print("Hata: ${e.message}");
      return [];
    }
  }

  Dio getDio() => _dio;
}

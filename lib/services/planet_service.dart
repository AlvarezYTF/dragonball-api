import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planet.dart';

class PlanetService {
  final String baseUrl = 'https://dragonball-api.com/api';

  Future<List<Planeta>> getPlanets() async {
    final response = await http.get(Uri.parse('$baseUrl/planets'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['items'];
      return jsonResponse.map((planet) => Planeta.fromJson(planet)).toList();
    } else {
      throw Exception('Error al cargar los planetas');
    }
  }
}

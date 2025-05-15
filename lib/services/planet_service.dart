import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planet.dart';

class PlanetService {
  final String baseUrl = 'https://dragonball-api.com/api';

  Future<List<Planeta>> getPlanets() async {
    final response = await http.get(Uri.parse('$baseUrl/planets?limit=1000'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'] ?? data;
      return items
          .map((json) => Planeta.fromJson(json))
          .where((planet) => planet.name.toLowerCase() != 'desconocido')
          .toList();
    } else {
      throw Exception('Error al cargar los planetas');
    }
  }

  Future<Planeta> getPlanetDetails(int planetId) async {
    final response = await http.get(Uri.parse('$baseUrl/planets/$planetId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Planeta.fromJson(data);
    } else {
      throw Exception('Error al cargar los detalles del planeta');
    }
  }
}
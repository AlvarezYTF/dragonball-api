import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planet.dart';

class PlanetService {
  final String apiUrl = 'https://dragonball-api.com/api/planets';

  Future<List<Planeta>> getAllPlanets() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      final List<dynamic> items = jsonMap['items']; // ✅ acceder al array dentro de 'items'

      return items.map((json) => Planeta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar planetas: ${response.statusCode}');
    }
  }
}

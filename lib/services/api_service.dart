import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  final String baseUrl = "https://dragonball-api.com/api";

Future<List<Personaje>> fetchAllCharacters() async {
  int currentPage = 1;
  int totalPages = 1;
  List<Personaje> allCharacters = [];

  do {
    final response = await http.get(
      Uri.parse('https://dragonball-api.com/api/characters?page=$currentPage'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['items'];
      final meta = jsonData['meta'];

      totalPages = meta['totalPages'];
      currentPage++;

      final characters = data.map((e) => Personaje.fromJson(e)).toList();
      allCharacters.addAll(characters);
    } else {
      throw Exception('Error al cargar personajes');
    }
  } while (currentPage <= totalPages);

  return allCharacters;
}
} 
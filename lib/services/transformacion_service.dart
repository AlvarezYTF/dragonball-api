import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transformation.dart';

class TransformacionService {
  final String _baseUrl = 'https://dragonball-api.com/api/transformations';

  Future<List<Transformacion>> fetchTransformaciones() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Transformacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las transformaciones');
    }
  }
}
import 'planet.dart';
import 'transformation.dart';

class Personaje {
  final int id;
  final String name;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String description;
  final String image;
  final String affiliation;
  final Planeta originPlanet;
  final List<Transformacion> transformations;

  Personaje({
    required this.id,
    required this.name,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.description,
    required this.image,
    required this.affiliation,
    required this.originPlanet,
    required this.transformations,
  });

 factory Personaje.fromJson(Map<String, dynamic> json) {
  return Personaje(
    id: json['id'],
    name: json['name'],
    ki: json['ki'],
    maxKi: json['maxKi'],
    race: json['race'],
    gender: json['gender'],
    description: json['description'],
    image: json['image'],
    affiliation: json['affiliation'],

    originPlanet: json['originPlanet'] != null
        ? Planeta.fromJson(json['originPlanet'])
        : Planeta(
            id: 0,
            name: 'Desconocido',
            isDestroyed: false,
            description: 'Sin información',
            image: '',
            characters: [],
          ),

    transformations: json['transformations'] != null
        ? (json['transformations'] as List)
            .map((t) => Transformacion.fromJson(t))
            .toList()
        : [],
  );
}
}
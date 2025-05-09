import 'character.dart';

class Planeta {
  final int id;
  final String name;
  final bool isDestroyed;
  final String description;
  final String image;
  final List<Personaje> characters;

  Planeta({
    required this.id,
    required this.name,
    required this.isDestroyed,
    required this.description,
    required this.image,
    required this.characters,
  });

  factory Planeta.fromJson(Map<String, dynamic> json) {
    return Planeta(
      id: json['id'],
      name: json['name'],
      isDestroyed: json['isDestroyed'],
      description: json['description'],
      image: json['image'],
      characters:
          (json['characters'] as List<dynamic>?)
              ?.map((c) => Personaje.fromJson(c))
              .toList() ??
          [],
    );
  }
}

import 'character.dart';

class Planeta {
  final int id;
  final String name;
  final String image;
  final String description;
  final bool isDestroyed; // ✅ Debe existir
  final List<dynamic> characters; // ✅ O ajusta el tipo si es otra clase

  Planeta({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.isDestroyed,
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

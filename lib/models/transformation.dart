class Transformacion {
  final int id;
  final String name;
  final String image;
  final String ki;
  final int personajeId; // <--- MUY IMPORTANTE

  // constructor, fromJson, etc.

  Transformacion({
    required this.id,
    required this.name,
    required this.image,
    required this.ki,
    required this.personajeId,
  });

  factory Transformacion.fromJson(Map<String, dynamic> json) {
    return Transformacion(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      ki: json['ki'],
      personajeId: json['personaje_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'ki': ki,
      'personaje_id': personajeId,
    };
  }
}
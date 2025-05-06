class Planeta {
  final int id;
  final String name;
  final String image;
  final String description;

  Planeta({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Planeta.fromJson(Map<String, dynamic> json) {
    return Planeta(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Desconocido',
      image:
          json['image'] ??
          'https://via.placeholder.com/150', // imagen por defecto
      description: json['description'] ?? 'Sin descripción disponible.',
    );
  }
}

class Transformacion {
  final int id;
  final String name;
  final String image;
  final String ki;

  Transformacion({
    required this.id,
    required this.name,
    required this.image,
    required this.ki,
  });

  factory Transformacion.fromJson(Map<String, dynamic> json) {
    return Transformacion(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      ki: json['ki'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'ki': ki,
    };
  }
}
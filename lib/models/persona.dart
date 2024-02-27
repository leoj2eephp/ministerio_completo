import 'dart:convert';

class Persona {
  int? id;
  String nombre;
  // String apellido;
  String observaciones;
  double lat;
  double lng;

  Persona({
    this.id,
    required this.nombre,
    // required this.apellido,
    required this.observaciones,
    required this.lat,
    required this.lng,
  });

  factory Persona.fromRawJson(String str) => Persona.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        id: json["id"],
        nombre: json["nombre"],
        // apellido: json["apellido"],
        observaciones: json["observaciones"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        // "apellido": apellido,
        "observaciones": observaciones,
        "lat": lat,
        "lng": lng,
      };
}

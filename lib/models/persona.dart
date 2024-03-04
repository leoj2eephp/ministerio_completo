import 'dart:convert';
import 'package:ministerio_completo/models/revisita.dart';

class Persona {
  int? id;
  String nombre;
  String fechaRegistro;
  String observaciones;
  double lat;
  double lng;
  List<Revisita> revisitas;
  int? cantRevisitas;

  Persona(
      {this.id,
      required this.nombre,
      required this.fechaRegistro,
      required this.observaciones,
      required this.lat,
      required this.lng,
      List<Revisita>? revisitas,
      this.cantRevisitas})
      : revisitas = revisitas ?? [];

  factory Persona.fromRawJson(String str) => Persona.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
      id: json["id"],
      nombre: json["nombre"],
      fechaRegistro: json["fechaRegistro"],
      observaciones: json["observaciones"] ?? "",
      lat: json["lat"]?.toDouble(),
      lng: json["lng"]?.toDouble(),
      revisitas: (json["revisitas"] != null)
          ? List<Revisita>.from(
              json["revisitas"].map((x) => Revisita.fromJson(x)))
          : [],
      cantRevisitas: json["cant_revisitas"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "fechaRegistro": fechaRegistro,
        "observaciones": observaciones,
        "lat": lat,
        "lng": lng,
      };
}

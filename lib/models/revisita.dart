import 'dart:convert';

class Revisita {
  int? id;
  String fecha;
  String observaciones;
  int personaId;

  Revisita(
      {this.id,
      required this.fecha,
      required this.observaciones,
      required this.personaId});

  factory Revisita.fromRawJson(String str) =>
      Revisita.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Revisita.fromJson(Map<String, dynamic> json) => Revisita(
        id: json["id"],
        fecha: json["fecha"],
        observaciones: json["observaciones"],
        personaId: json["persona_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "observaciones": observaciones,
        "persona_id": personaId,
      };
}

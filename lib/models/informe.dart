import 'dart:convert';

class Informe {
  int? id;
  String fecha;
  int minutosTotales;

  Informe({
    this.id,
    required this.fecha,
    required this.minutosTotales,
  });

  factory Informe.fromRawJson(String str) => Informe.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Informe.fromJson(Map<String, dynamic> json) => Informe(
        id: json["id"],
        fecha: json["fecha"],
        minutosTotales: json["minutosTotales"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "minutosTotales": minutosTotales,
      };

  String get formatoHora {
    final horasTotales = Duration(minutes: minutosTotales);
    return "${horasTotales.inHours.toString().padLeft(2, "0")}:${(horasTotales.inMinutes % 60).toString().padLeft(2, "0")}";
  }

  String getMes() {
    if (fecha.length <= 7) {
      return fecha.substring(0, 2);
    } else {
      return fecha.substring(5, 7);
    }
  }

  String getNombreMes() {
    String mes = getMes();
    switch (int.parse(mes)) {
      case 1:
        return "Enero";
      case 2:
        return "Febrero";
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
      case 5:
        return "Mayo";
      case 6:
        return "Junio";
      case 7:
        return "Julio";
      case 8:
        return "Agosto";
      case 9:
        return "Septiembre";
      case 10:
        return "Octubre";
      case 11:
        return "Noviembre";
      case 12:
        return "Diciembre";
      default:
        return "Mes no válido";
    }
  }
}

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/models/revisita.dart';
import 'package:ministerio_completo/providers/db_provider.dart';

class RevisitaProvider extends ChangeNotifier {
  int? id;
  DateTime _fecha = DateTime.now();
  String _observaciones = "";
  int? personaId;

  DateTime get fecha => _fecha;
  String get observaciones => _observaciones;
  final Logger _logger = Logger();

  set fecha(DateTime value) {
    _fecha = value;
    notifyListeners();
  }

  set observaciones(String value) {
    _observaciones = value;
    notifyListeners();
  }

  void clear() {
    id = null;
    _fecha = DateTime.now();
    _observaciones = "";
    personaId = null;
  }

  String get fechaFormateadaBD {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  String get fechaFormateadaCliente {
    return "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year}";
  }

  void save() async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      final revisita = Revisita(
          fecha: fechaFormateadaBD,
          observaciones: observaciones,
          personaId: personaId);
      db.insert("revisita", revisita.toJson());
      clear();
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<List<Revisita>> getAll() async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      final data = await db.query("revisita");
      return data.map((r) => Revisita.fromJson(r)).toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<List<Persona>> getRevisitasPersonas() async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      final result = await db.rawQuery("""
        SELECT persona.*, revisita.id as revisitaId, revisita.fecha,
          revisita.observaciones as revisitaObservaciones, revisita.personaId
        FROM persona
        LEFT JOIN revisita ON persona.id = revisita.personaId
      """);
      // var personas = result.map((r) => Persona.fromJson(r)).toList();
      return result.map((r) {
        var personas = Persona.fromJson(r);
        personas.revisitas.add(Revisita(
            fecha: r["fecha"].toString(),
            observaciones: r["revisitaObservaciones"].toString(),
            id: int.tryParse(
              r["revisitaId"].toString(),
            )));
        return personas;
      }).toList();
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<List<Revisita>> getRevisitasPorPersona(int personaId) async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      final data = await db.query("revisita",
          where: "personaId = ?",
          whereArgs: [personaId],
          orderBy: "fecha DESC");
      return data.map((r) => Revisita.fromJson(r)).toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<int> getSumaRevisitasPorPersona(int personaId) async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      const sql =
          "SELECT COUNT(id) cantidad FROM revisita WHERE personaId = ? GROUP BY personaId";
      final result = await db.rawQuery(sql, [personaId]);
      return int.tryParse(result.first["cantidad"].toString()) ?? 0;
    } catch (e) {
      _logger.e(e);
    }

    return 0;
  }
}

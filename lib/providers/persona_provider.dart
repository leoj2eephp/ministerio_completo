import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/db_provider.dart';

class PersonaProvider extends ChangeNotifier {
  int? id;
  String nombre = "";
  String apellido = "";
  String observaciones = "";
  double latitud = 0;
  double longitud = 0;
  bool actualizando = false;

  final Logger _logger = Logger();
  Set<Marker> marcadores = {};

  void addMarcadores(List<Persona> listaPersonas) {
    // marcadores.clear();
    for (var p in listaPersonas) {
      final latlng = LatLng(p.lat, p.lng);
      /* marcadores.add(Marker(
      markerId: MarkerId(p.id.toString()),
      position: latlng,
    )); */
    }
  }

  void updateLocation(double newLatitud, double newLongitud) {
    latitud = newLatitud;
    longitud = newLongitud;

    marcadores.clear();
    notifyListeners();
  }

  void clear() {
    id = null;
    nombre = "";
    apellido = "";
    observaciones = "";
    latitud = 0;
    longitud = 0;
    actualizando = false;
  }

  Future save() async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      final personita = Persona(
        nombre: nombre,
        // apellido: apellido,
        observaciones: observaciones,
        lat: latitud,
        lng: longitud,
      );
      if (id != null) {
        personita.id = id;
        db.update("persona", personita.toJson(),
            where: "id = ?", whereArgs: [id]);
        clear();
      } else {
        db.insert("persona", personita.toJson());
        clear();
      }
      notifyListeners();
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<List<Persona>> getAll() async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      final listaPersonas = await db.query("persona");
      return listaPersonas.map((e) => Persona.fromJson(e)).toList();
    } catch (e) {
      _logger.e(e);
    }
    return [];
  }

  Future<int> delete(int id) async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    try {
      return await db.delete("persona", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      _logger.e(e);
      return 0;
    }
  }
}

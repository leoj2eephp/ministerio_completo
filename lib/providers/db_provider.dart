import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ministerio_completo/models/informe.dart';
import 'package:ministerio_completo/providers/registro_actividad_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class DBProvider extends ChangeNotifier {
  static Database? _database;
  final Logger logger = Logger();

  final String _sqlCreateInforme =
      "CREATE TABLE informe (id INTEGER PRIMARY KEY AUTOINCREMENT, fecha TEXT, minutosTotales INTEGER)";
  final String _sqlCreatePersona =
      """CREATE TABLE persona (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, fechaRegistro TEXT,
                              observaciones TEXT, lat DOUBLE, lng DOUBLE)""";
  final String _sqlCreateRevisita =
      """ CREATE TABLE revisita (id INTEGER PRIMARY KEY AUTOINCREMENT, fecha TEXT, observaciones TEXT,
                              personaId INTEGER) """;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String directorio = await getDatabasesPath();
    String path = join(directorio, "ministerio.db");

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(_sqlCreateInforme);
        await db.execute(_sqlCreatePersona);
        await db.execute(_sqlCreateRevisita);
      },
    );
  }

  Future<int> insertActividad(RegistroActividadProvider registroInforme) async {
    int resultado = -1;
    final db = await database;
    try {
      final informito = Informe(
          fecha: registroInforme.fechaFormateada,
          minutosTotales: registroInforme.actividadTotal);
      resultado = await db.insert("informe", informito.toJson());
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }

    return resultado;
  }

  Future<List<Informe>> getAllActividad() async {
    try {
      final db = await database;
      final datos = await db.query("informe");
      return datos.map((e) => Informe.fromJson(e)).toList();
    } catch (e) {
      logger.e(e);
    }

    return [];
  }

  Future<List<Informe>> getActividadAgrupadaPorMes() async {
    try {
      final db = await database;
      var resultado = await db.rawQuery(
          "SELECT STRFTIME('%Y', fecha) as anio, STRFTIME('%m-%Y', fecha) AS mes, SUM(minutosTotales) AS minutosTotales FROM informe GROUP BY STRFTIME('%m-%Y', fecha) ORDER BY anio DESC, mes DESC");
      return resultado
          .map((e) => Informe(
                // id: 1,
                fecha: e["mes"].toString(),
                minutosTotales: int.parse(e["minutosTotales"].toString()),
              ))
          .toList();
    } catch (e) {
      logger.e(e);
    }

    return [];
  }

  Future<List<Informe>> getActividadMes(Informe informe) async {
    try {
      final db = await database;
      var resultado = await db.rawQuery(
          "SELECT * FROM informe WHERE STRFTIME('%m-%Y', fecha) = ? ORDER BY fecha DESC",
          [informe.fecha]);
      return resultado.map((e) => Informe.fromJson(e)).toList();
    } catch (e) {
      logger.e(e);
    }

    return [];
  }

  Future<int> deleteActividad(int id) async {
    try {
      final db = await database;
      var resultado = db.delete("informe", where: "id = ?", whereArgs: [id]);
      return resultado;
    } catch (e) {
      logger.e(e);
      return 0;
    }
  }
}

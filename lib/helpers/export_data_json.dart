import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String> getDatabasePathJSON() async {
  final dbProvider = DBProvider();
  final database = await dbProvider.database;
  // Obtener la lista de tablas en la base de datos
  List<Map<String, dynamic>> tables = await database.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table';",
  );
  // Mapa para almacenar los datos de todas las tablas
  Map<String, List<Map<String, dynamic>>> allTableData = {};
// Exportar cada tabla a JSON
  for (Map<String, dynamic> table in tables) {
    String tableName = table['name'];
    List<Map<String, dynamic>> tableData = await database.query(tableName);
    allTableData[tableName] = tableData;
  }
  // Exportar todos los datos a un solo archivo JSON
  return await _exportAllTablesToJSON(allTableData);
}

Future<void> exportDatabaseToJSON(BuildContext context) async {
  final path = await getDatabasePathJSON();
  // Mostrar menú de compartir
  final fileName = XFile(path);
  Share.shareXFiles([fileName]);
}

Future<String> _exportAllTablesToJSON(
    Map<String, List<Map<String, dynamic>>> allTableData) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/ministerio.json';
  final file = File(path);
  // Crear un mapa para almacenar los datos de todas las tablas
  Map<String, dynamic> jsonData = {};
  for (String tableName in allTableData.keys) {
    jsonData[tableName] = allTableData[tableName];
  }

  await file.writeAsString(jsonEncode(jsonData));
  return path;
}

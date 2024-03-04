import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> exportDatabaseToJSON(Database database) async {
  // Obtener la lista de tablas en la base de datos
  List<Map<String, dynamic>> tables = await database.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table';",
  );

  // Exportar cada tabla a JSON
  for (Map<String, dynamic> table in tables) {
    String tableName = table['name'];
    List<Map<String, dynamic>> tableData = await database.query(tableName);
    await _exportTableToJSON(tableName, tableData);
  }
}

Future<void> _exportTableToJSON(
    String tableName, List<Map<String, dynamic>> data) async {
  final directory = await getExternalStorageDirectory();
  final file = File('${directory!.path}/$tableName.json');
  final jsonData = jsonEncode(data);
  await file.writeAsString(jsonData);
}

void main() async {
  // Abrir la base de datos
  final databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'your_database.db');
  final Database database = await openDatabase(path);

  // Exportar la base de datos a JSON
  await exportDatabaseToJSON(database);

  // Cerrar la base de datos
  await database.close();

  print('Base de datos exportada exitosamente.');
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:logger/logger.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:sqflite/sqflite.dart';

Logger _logger = Logger();

Future<bool> importFile() async {
  const params = OpenFileDialogParams(
    dialogType: OpenFileDialogType.document,
    sourceType: SourceType.photoLibrary,
  );
  final filePath = await FlutterFileDialog.pickFile(params: params);

  if (!await FlutterFileDialog.isPickDirectorySupported()) {
    throw Exception("No se ha dado permisos para la selección de directorio");
  }

  if (filePath != null) {
    // Obtener la ruta de la carpeta de las bases de datos de tu aplicación
    final databasesDirectory = await getDatabasesPath();

    // Copiar el archivo seleccionado a esa ubicación
    final file = File(filePath);
    final fileName = file.path.split('/').last; // Obtener el nombre del archivo
    final newFilePath = '$databasesDirectory/$fileName';
    await file.copy(newFilePath);

    _readAndReplaceDatabaseFromJSON(newFilePath);
    return true;
  } else {
    return false;
    //throw Exception("No se seleccionó ninguna carpeta");
  }
}

Future<void> _readAndReplaceDatabaseFromJSON(String filePath) async {
  try {
    final File file = File(filePath);
    final jsonString = await file.readAsString();
    final jsonData = jsonDecode(jsonString);
    await replaceDatabaseWithData(jsonData);
  } catch (e) {
    _logger.e(
        'Error al leer y reemplazar la base de datos desde el archivo JSON: $e');
  }
}

Future<void> replaceDatabaseWithData(dynamic jsonData) async {
  final dbProvider = DBProvider();
  final database = await dbProvider.database;
  try {
    // Eliminar todos los datos de las tablas existentes
    await clearDatabase(database);
    // Insertar los datos del JSON en las tablas
    // Iterar sobre las claves del mapa
    for (final tableName in jsonData.keys) {
      // Obtener la lista de objetos para esta tabla
      final List<dynamic> tableData = jsonData[tableName];
      // Insertar los datos en la tabla
      for (final item in tableData) {
        await database.insert(tableName, item);
      }
    }
  } catch (e) {
    final Logger logger = Logger();
    logger.e("Error al reemplazar la base de datos con los datos del JSON: $e");
  }
}

Future<void> clearDatabase(Database database) async {
  var tableNames = (await database
          .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
      .map((row) => row['name'] as String)
      .toList(growable: false);

  for (final table in tableNames) {
    await database.delete(table);
    await database.rawDelete('DELETE FROM $table');
    await database.rawDelete('VACUUM');
  }
}

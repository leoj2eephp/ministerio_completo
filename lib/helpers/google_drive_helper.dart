import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:ministerio_completo/helpers/export_data_json.dart';
import 'package:ministerio_completo/helpers/logger_helper.dart';
import 'package:ministerio_completo/models/auth_credentials_serializable.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> uploadJsonToDrive() async {
  try {
    // Genero el archivo JSON
    final jsonFilePath = await getDatabasePathJSON();
    final jsonFile = File(jsonFilePath);

    if (!jsonFile.existsSync()) {
      LoggerHelper.info('El archivo JSON no existe en la ruta especificada.');
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonAuthClient = jsonDecode(prefs.getString("authClient") ?? "");
    if (jsonAuthClient == null || jsonAuthClient == "") return false;

    final credentialsMap =
        jsonDecode(prefs.getString("authClient") ?? "") as Map<String, dynamic>;
    final credentialsSerializable =
        AuthCredentialsSerializable.fromJson(credentialsMap);

    var credentials = credentialsSerializable.toAccessCredentials();
    if (credentials.accessToken.expiry.isBefore(DateTime.now().toUtc())) {
      LoggerHelper.info("El token ha expirado. Intentando renovar...");

      final googleUser = await GoogleSignIn().signInSilently();
      if (googleUser == null) {
        LoggerHelper.error("El usuario no está autenticado.");
        return false;
      }

      final auth = await googleUser.authentication;
      credentials = AccessCredentials(
        AccessToken("Bearer", auth.accessToken!,
            DateTime.now().add(const Duration(hours: 1)).toUtc()),
        null,
        credentials.scopes,
        idToken: auth.idToken,
      );

      final newJson =
          AuthCredentialsSerializable.fromAccessCredentials(credentials);
      prefs.setString("authClient", jsonEncode(newJson));

      LoggerHelper.info("Nuevo token obtenido y guardado.");
    }

    // Cliente autenticado con el token más reciente
    final authClient = authenticatedClient(http.Client(), credentials);
    final driveApi = drive.DriveApi(authClient);

    // Obtengo o creo la estructura de carpetas
    final now = DateTime.now();
    final folderPath = 'ministerio_completo/${now.year}/${now.month}';
    final fileName = 'ministerio_${now.day}.json';
    final folderId = await getOrCreateFolder(driveApi, folderPath);

    // Preparo el archivo para subir
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [folderId];

    // Sube el archivo a Google Drive
    final media = drive.Media(jsonFile.openRead(), jsonFile.lengthSync());
    final response = await driveApi.files.create(driveFile, uploadMedia: media);

    LoggerHelper.info(
        'Archivo subido exitosamente: ${response.name} (ID: ${response.id})');
    return true;
  } catch (e) {
    LoggerHelper.error('Error al subir el archivo JSON: $e');
    return false;
  }
}

Future<String> getOrCreateFolder(drive.DriveApi driveApi, String path) async {
  List<String> folderNames = path.split('/');
  String? pFolderId;

  for (String folderName in folderNames) {
    pFolderId = await getOrCreateSingleFolder(driveApi, folderName, pFolderId);
  }

  return pFolderId!;
}

Future<String> getOrCreateSingleFolder(
    drive.DriveApi driveApi, String folderName, String? parentId) async {
  try {
    String query =
        "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    if (parentId != null) {
      query += " and '$parentId' in parents";
    }

    final fileList = await driveApi.files.list(q: query, spaces: 'drive');

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first.id!;
    }

    final folder = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = parentId != null ? [parentId] : null;

    final createdFolder = await driveApi.files.create(folder);
    return createdFolder.id!;
  } catch (e) {
    throw Exception('Error al buscar o crear la carpeta: $e');
  }
}

Future<AccessCredentials?> obtainAccessCredentialsViaRefreshToken(
    http.Client client, String refreshToken, List<String> scopes,
    {required String clientId, required String clientSecret}) async {
  try {
    final response = await client.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final accessToken = AccessToken(
        'Bearer',
        responseData['access_token'],
        DateTime.now().add(Duration(seconds: responseData['expires_in'])),
      );
      return AccessCredentials(accessToken, refreshToken, scopes);
    } else {
      LoggerHelper.error(
          'Error al refrescar el token: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    LoggerHelper.error('Error en la solicitud de refresco: $e');
    return null;
  }
}

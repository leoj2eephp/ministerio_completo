import 'package:googleapis_auth/auth_io.dart';

class AuthCredentialsSerializable {
  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime expiry; // Importante guardar la fecha de expiración

  AuthCredentialsSerializable({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    required this.expiry,
  });

  // Método para convertir el objeto a un mapa (para JSON)
  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'idToken': idToken,
        'expiry':
            expiry.millisecondsSinceEpoch, // Guarda la fecha como milisegundos
      };

  // Método para crear un objeto desde un mapa (desde JSON)
  factory AuthCredentialsSerializable.fromJson(Map<String, dynamic> json) =>
      AuthCredentialsSerializable(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String?,
        idToken: json['idToken'] as String?,
        expiry: DateTime.fromMillisecondsSinceEpoch(json['expiry'] as int),
      );

  // Método para crear un objeto desde AccessCredentials
  factory AuthCredentialsSerializable.fromAccessCredentials(
          AccessCredentials credentials) =>
      AuthCredentialsSerializable(
        accessToken: credentials.accessToken.data,
        refreshToken: credentials.refreshToken,
        idToken: credentials.idToken,
        expiry: credentials.accessToken.expiry,
      );

  AccessCredentials toAccessCredentials() => AccessCredentials(
        AccessToken('Bearer', accessToken, expiry.toUtc()),
        refreshToken,
        [],
        idToken: idToken,
      );
}

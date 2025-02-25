import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:ministerio_completo/helpers/logger_helper.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
      'https://www.googleapis.com/auth/drive',
    ],
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      return _googleSignIn.currentUser;
    } catch (error) {
      LoggerHelper.error('Error signing in: $error');
      return null;
    }
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<AuthClient?> getAuthClient(GoogleSignInAccount? user) async {
    if (user == null) return null;

    try {
      final GoogleSignInAuthentication googleAuth = await user.authentication;

      if (googleAuth.accessToken == null) {
        LoggerHelper.warning(
            "Access token is null. User might not have granted permissions.");
        return null;
      }

      final accessToken = AccessToken(
        'Bearer', // Tipo de token (generalmente 'Bearer')
        googleAuth.accessToken!,
        DateTime.now().add(const Duration(hours: 1)).toUtc(),
      );

      final credentials = AccessCredentials(
        accessToken,
        null,
        [], // Scopes (pueden estar vacíos, ya se definieron al iniciar sesión)
        idToken: googleAuth.idToken,
      );

      return authenticatedClient(http.Client(), credentials);
    } catch (e) {
      LoggerHelper.error('Error getting auth client: $e');
      return null;
    }
  }
}

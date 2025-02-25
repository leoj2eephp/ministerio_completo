import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ministerio_completo/helpers/google_drive_helper.dart';
import 'package:ministerio_completo/helpers/google_sign_in_helper.dart';
import 'package:ministerio_completo/models/auth_credentials_serializable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ministerio_completo/helpers/fechas.dart' as fechas;

class ConfigProvider extends ChangeNotifier {
  bool _isSyncEnabled = false;
  bool _isSignIn = false;
  String? _lastSyncDate;

  bool get isSyncEnabled => _isSyncEnabled;
  bool get isSignIn => _isSignIn;
  String? get lastSyncDate => _lastSyncDate;
  String get lastSyncDateFormatted {
    if (_lastSyncDate != null) {
      return fechas.getFechaFormatoChile(_lastSyncDate!);
    } else {
      SharedPreferences.getInstance().then((prefs) {
        String? lastSync = prefs.getString('last_sync_date');
        _lastSyncDate = lastSync;
        notifyListeners();
      });
      return _lastSyncDate ?? "Nunca";
    }
  }

  void syncEnabled(bool value) async {
    _isSyncEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("sync_enabled", value);
    notifyListeners();
  }

  ConfigProvider() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isSyncEnabled = prefs.getBool('sync_enabled') ?? false;
    notifyListeners();
  }

  Future<void> updateLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString('last_sync_date', today);
    _lastSyncDate = today;
    notifyListeners();
  }

  Future<bool> toggleSync(bool value) async {
    _isSyncEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('sync_enabled', value);

    if (value) {
      final signIn = GoogleSignInHelper();
      final googleAccount = await signIn.signInWithGoogle();
      if (googleAccount == null) return false;

      final authClient = await signIn.getAuthClient(googleAccount);
      if (authClient == null) return false;

      final json = AuthCredentialsSerializable.fromAccessCredentials(
          authClient.credentials);
      prefs.setString("authClient", jsonEncode(json));

      String? lastSync = prefs.getString('last_sync_date');
      String today = DateTime.now().toIso8601String().split('T')[0];
      if (lastSync == null || lastSync != today) {
        final result = await uploadJsonToDrive();
        if (result) {
          await updateLastSyncDate();
          _lastSyncDate = today;
        }
      }
    } else {
      // Si se desactiva, se podría detener algún servicio o simplemente dejar de sincronizar.
    }

    notifyListeners();
    return true;
  }

  Future<void> verifySignIn() async {
    final googleAccount = await GoogleSignInHelper().signInWithGoogle();
    _isSignIn = googleAccount != null;
    notifyListeners();
    /* final authClient = await singIn.getAuthClient(googleAccount);
    return authClient != null; */
    /* setState(() {
        isSyncActive = true;
      }); */
    // uploadJsonToDrive(authClient);
  }
}

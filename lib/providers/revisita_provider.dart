import 'package:flutter/material.dart';

class RevisitaProvider extends ChangeNotifier {
  int? id;
  DateTime _fecha = DateTime.now();
  String _observaciones = "";
  int personaId = 0;

  DateTime get fecha => _fecha;
  String get observaciones => _observaciones;

  set fecha(DateTime value) {
    _fecha = value;
    notifyListeners();
  }

  set observaciones(String value) {
    _observaciones = value;
    notifyListeners();
  }

  String get fechaFormateadaCliente {
    return "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year}";
  }
}

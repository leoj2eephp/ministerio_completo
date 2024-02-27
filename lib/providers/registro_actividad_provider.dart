import 'package:flutter/material.dart';

class RegistroActividadProvider extends ChangeNotifier {
  DateTime _fecha = DateTime.now();
  int _actividadTotal = 0;
  int _minutos = 0;
  int _horas = 0;

  int get minutos => _minutos;

  set minutos(int value) {
    _minutos = value;
    calcularActividadTotal();
    notifyListeners();
  }

  int get horas => _horas;

  set horas(int value) {
    _horas = value;
    calcularActividadTotal();
    notifyListeners();
  }

  DateTime get fecha => _fecha;

  set fecha(DateTime value) {
    _fecha = value;
    notifyListeners();
  }

  String get horaFormateada {
    return horas.toString().padLeft(2, "0");
  }

  String get minutosFormateados {
    return minutos.toString().padLeft(2, "0");
  }

  String get fechaFormateada {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  String get fechaFormateadaCliente {
    return "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year}";
  }

  int get actividadTotal => _actividadTotal;
  calcularActividadTotal() => _actividadTotal = (horas * 60) + minutos;

  void limpiarCampos() {
    _fecha = DateTime.now();
    _actividadTotal = 0;
    _minutos = 0;
    _horas = 0;
  }
}

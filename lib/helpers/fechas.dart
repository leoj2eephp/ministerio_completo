import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ministerio_completo/helpers/fechas.dart' as date_helper;

String getDayNameFromDate(DateTime date) {
  final DateFormat formatter = DateFormat('EEEE', 'es');
  final String dayName = formatter.format(date);
  return dayName;
}

String getDayNameFromString(String fecha) {
  final DateTime? date = DateTime.tryParse(fecha);
  if (date != null) {
    final DateFormat formatter = DateFormat('EEEE', 'es');
    final String dayName = formatter.format(date);
    return dayName.substring(0, 1).toUpperCase() + dayName.substring(1);
  } else {
    return "Fecha no soportada";
  }
}

String getMonthFromDate(DateTime date) {
  final DateFormat formatter = DateFormat('MMMM', 'es');
  final String dayName = formatter.format(date);
  return dayName;
}

String getMonthFromString(String fecha) {
  final DateTime date = DateTime.parse(fecha);
  final DateFormat formatter = DateFormat('MMMM', 'es');
  final String dayName = formatter.format(date);
  return dayName;
}

String getFechaCompletaEscrita(DateTime date) {
  return "${date_helper.getDayNameFromDate(date)} ${date.day} de ${date_helper.getMonthFromDate(date)} del ${date.year}";
}

String getFechaCompletaEscritaFromString(String fecha) {
  DateTime date = DateTime.parse(fecha);
  return "${date_helper.getDayNameFromDate(date)} ${date.day} de ${date_helper.getMonthFromDate(date)} del ${date.year}";
}

import 'package:logger/logger.dart';

class LoggerHelper {
  static final _logger = Logger();

  static void error(String mensaje) {
    _logger.e(mensaje);
  }

  static void info(String mensaje) {
    _logger.i(mensaje);
  }

  static void warning(String mensaje) {
    _logger.w(mensaje);
  }
}

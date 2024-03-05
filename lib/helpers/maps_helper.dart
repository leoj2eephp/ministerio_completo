import 'package:location/location.dart' as loc;

Future<loc.LocationData> getLocation() async {
    try {
      loc.Location location = loc.Location();
      //loc.LocationData ubicacionActual = await location.getLocation();
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        // Si el servicio no está habilitado, solicitar al usuario que lo habilite
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          // Si el usuario no habilita el servicio, manejar el caso aquí
          throw Exception("No está habilitado el servicio de mapas");
        }
      }

      var permissionStatus = await loc.Location().hasPermission();
      if (permissionStatus == loc.PermissionStatus.denied) {
        // Si el permiso de ubicación está denegado, solicitar al usuario que lo conceda
        permissionStatus = await loc.Location().requestPermission();
        if (permissionStatus != loc.PermissionStatus.granted) {
          // Si el usuario no concede el permiso, manejar el caso aquí
          throw Exception("Sin permisos para ubicación");
        }
      }

      final ubicacionActual = await location.getLocation();
      return ubicacionActual;
    } catch (e) {
      throw Exception("Error al cargar maps");
    }
  }
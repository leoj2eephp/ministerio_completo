import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:provider/provider.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personaPro = Provider.of<PersonaProvider>(context, listen: false);
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();

    return FutureBuilder(
      future: fetchData(personaPro),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error al cargar Maps: ${snapshot.error}");
        }

        final data = snapshot.data!;
        final loc.LocationData gpsLocation = data[0];
        final List<Persona> listaPersonas = data[1];
        // final Set<Marker> marcadores = <Marker>{};
        personaPro.addMarcadores(listaPersonas);

        /* personaPro.marcadores
              .addLabelMarker(LabelMarker(
                label: p.nombre,
                markerId: MarkerId(
                  p.nombre,
                ),
                position: latlng,
                backgroundColor: Colors.green,
              ))
              .then((value) => personaPro.marcadores = {}); */

        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(gpsLocation.latitude!, gpsLocation.longitude!),
          zoom: 16,
        );

        return SizedBox(
          height: 200,
          child: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: cameraPosition,
            markers: personaPro.marcadores,
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        );
      },
    );
  }

  Future<List> fetchData(PersonaProvider personaProvider) async {
    // Esperamos a que ambas llamadas asíncronas se completen
    final results =
        await Future.wait([_getLocation(), personaProvider.getAll()]);
    return results;
  }

  Future<loc.LocationData> _getLocation() async {
    loc.Location location = loc.Location();
    loc.LocationData ubicacionActual = await location.getLocation();

    return ubicacionActual;
  }
}

import 'dart:async';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_completo/helpers/maps_helper.dart' as mapHelper;

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personaPro = Provider.of<PersonaProvider>(context);
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();
    List<MarkerData> customMarkers = [];

    return Scaffold(
      appBar: AppBar(title: const Text("Personas que mostraron interés")),
      body: FutureBuilder(
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

          for (var perso in listaPersonas) {
            customMarkers.add(
              MarkerData(
                marker: Marker(
                    markerId: MarkerId(perso.id.toString()),
                    position: LatLng(perso.lat, perso.lng),
                    infoWindow: InfoWindow(title: perso.observaciones)),
                child: _customMarker(
                    perso.nombre, Theme.of(context).colorScheme.primary),
              ),
            );
          }

          CameraPosition cameraPosition = CameraPosition(
            target: LatLng(gpsLocation.latitude!, gpsLocation.longitude!),
            zoom: 16,
          );

          return SizedBox(
            child: CustomGoogleMapMarkerBuilder(
              customMarkers: customMarkers,
              builder: (_, Set<Marker>? markers) {
                if (markers == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GoogleMap(
                  mapType: personaPro.tipoMapa,
                  initialCameraPosition: cameraPosition,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: true,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          personaPro.tipoMapa = personaPro.tipoMapa == MapType.hybrid
              ? MapType.none
              : MapType.hybrid;
        },
        child: const Icon(Icons.layers),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<List> fetchData(PersonaProvider personaProvider) async {
    // Esperamos a que ambas llamadas asíncronas se completen
    final results =
        await Future.wait([mapHelper.getLocation(), personaProvider.getAll()]);
    return results;
  }

  _customMarker(String text, Color color) {
    return Column(
      children: [
        Container(
          // margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: color, blurRadius: 6)]),
          child: Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(fontSize: 14, color: color),
              ),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(20, 10),
          painter: TrianglePainter(color: color),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

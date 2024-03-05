import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as loc;
import 'package:ministerio_completo/helpers/maps_helper.dart' as mapHelper;

class PersonasScreen extends StatelessWidget {
  const PersonasScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final persona = args?["personita"];
    final personaProvider = Provider.of<PersonaProvider>(context);
    if (persona != null) {
      personaProvider.id = persona!.id;
      if (!personaProvider.actualizando) {
        personaProvider.nombre = persona!.nombre;
        personaProvider.observaciones = persona!.observaciones;
        personaProvider.latitud = persona!.lat;
        personaProvider.longitud = persona!.lng;
      }
    } else {
      if (!personaProvider.actualizando) personaProvider.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Persona'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      personaProvider.nombre = value;
                    },
                    initialValue: persona?.nombre ?? "",
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      personaProvider.observaciones = value;
                    },
                    initialValue: persona?.observaciones ?? "",
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const Divider(height: 40),
                  _googleMaps(personaProvider),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        personaProvider.save();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add), label: const Text("Guardar"),
                      // color: Theme,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<loc.LocationData> _googleMaps(PersonaProvider personaProvider) {
    return FutureBuilder(
        future: mapHelper.getLocation(),
        builder: (context, snapshot) {
          final Completer<GoogleMapController> mapController =
              Completer<GoogleMapController>();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error al cargar Maps: ${snapshot.error}");
          }

          final ubicacion = snapshot.data!;
          final latitud = personaProvider.latitud != 0
              ? personaProvider.latitud
              : ubicacion.latitude!;
          final longitud = personaProvider.longitud != 0
              ? personaProvider.longitud
              : ubicacion.longitude!;

          final latlng = LatLng(latitud, longitud);
          CameraPosition cameraPosition = CameraPosition(
            target: latlng,
            zoom: 17,
          );

          personaProvider.latitud = latitud;
          personaProvider.longitud = longitud;
          personaProvider.marcadores = {
            Marker(
              markerId: const MarkerId('mi-ubicacion'),
              position: latlng,
            )
          };

          return SizedBox(
            height: 280,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: cameraPosition,
              markers: personaProvider.marcadores,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
              onLongPress: (posicion) {
                personaProvider.actualizando = true;
                personaProvider.updateLocation(
                    posicion.latitude, posicion.longitude);
              },
            ),
          );
        });
  }
}

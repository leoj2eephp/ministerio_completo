import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/persona.dart';

class PersonaListTile extends StatelessWidget {
  final Persona personita;
  final Future<int> Function(int)? onDismissible;
  final Function() onTap;
  const PersonaListTile(
      {super.key,
      required this.personita,
      this.onDismissible,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (onDismissible != null) {
      return Dismissible(
        key: Key(personita.id.toString()),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: _customListTile(context),
      );
    } else {
      return _customListTile(context);
    }
  }

  _customListTile(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: ListTile(
        title: Text(personita.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Primer registro: ${personita.fechaRegistro}\n${personita.observaciones}"),
            /* Text("Lat: ${personita.lat}"),
                            Text("Lng: ${personita.lng}"), */
          ],
        ),
        leading: const Icon(Icons.person),
        trailing: const Icon(Icons.gps_fixed),
        onTap: () => onTap(),
      ),
    );
  }
}

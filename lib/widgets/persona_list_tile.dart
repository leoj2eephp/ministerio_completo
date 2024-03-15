import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/helpers/custom_dialogs.dart'
    as custom_dialogs;
import 'package:ministerio_completo/helpers/fechas.dart' as fechas_helper;

class PersonaListTile extends StatelessWidget {
  final Persona personita;
  final Function()? onDismissible;
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
        onDismissed: (direction) => onDismissible!(),
        confirmDismiss: (direction) async {
          return await custom_dialogs.showConfirmDialog(
              context,
              "Confirmar Eliminación",
              "¿Estás seguro de que deseas eliminar este elemento?",
              Icons.delete,
              Colors.red);
        },
      );
    } else {
      return _customListTile(context);
    }
  }

  _customListTile(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.lightBlue.shade100,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: ListTile(
        title: Text(personita.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Primer registro: ${fechas_helper.getFechaFormatoChile(personita.fechaRegistro)}\n${personita.observaciones}"),
          ],
        ),
        leading: const Icon(Icons.person),
        trailing: const Icon(Icons.gps_fixed),
        onTap: () => onTap(),
      ),
    );
  }
}

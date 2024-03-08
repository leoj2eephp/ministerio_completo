import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:provider/provider.dart';

class SimplePersonaListTile extends StatelessWidget {
  final Persona personita;
  final Future<int> Function(int)? onDismissible;
  final Function() onTap;
  const SimplePersonaListTile(
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
    final revisitaProvider = Provider.of<RevisitaProvider>(context);
    return FutureBuilder(
      future: revisitaProvider.getSumaRevisitasPorPersona(personita.id!),
      builder: (context, snapshot) => Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: ListTile(
          title: Center(child: Text(personita.nombre)),
          subtitle: Text(
              "Primer registro: ${personita.fechaRegistro}\nRevisitas hechas: ${snapshot.data}"),
          leading: const Icon(Icons.person),
          trailing: const Icon(Icons.my_library_books),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}

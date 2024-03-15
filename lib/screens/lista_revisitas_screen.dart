import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:ministerio_completo/widgets/custom_error.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_completo/helpers/fechas.dart' as date_helper;
import 'package:ministerio_completo/helpers/custom_dialogs.dart'
    as custom_dialogs;

class ListaRevisitasScreen extends StatelessWidget {
  const ListaRevisitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revisitaProvider = Provider.of<RevisitaProvider>(context);
    final personita = ModalRoute.of(context)!.settings.arguments as Persona;
    return Scaffold(
      appBar:
          AppBar(title: Text("Revisitas a ${personita.nombre.trim()} hechas")),
      body: FutureBuilder(
        future: revisitaProvider.getRevisitasPorPersona(personita.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final revisita = snapshot.data!;
            if (revisita.isEmpty) {
              return const CustomError(
                errorMsg: "No hay revisitas registradas a esta persona.",
                icon: Icons.warning,
                color: Colors.yellow,
              );
            }
            return ListView.builder(
                itemCount: revisita.length,
                itemBuilder: (_, index) {
                  final revisitita = revisita[index];
                  return Dismissible(
                    key: Key(revisitita.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) =>
                        revisitaProvider.delete(revisitita.id!),
                    confirmDismiss: (direction) async =>
                        await custom_dialogs.showConfirmDialog(
                            context,
                            "Confirmación de Eliminación",
                            "¿Estás seguro de que deseas eliminar este elemento?",
                            Icons.delete,
                            Colors.red),
                    child: Card(
                      elevation: .5,
                      child: ListTile(
                        title: Text(
                            "Fecha: ${date_helper.getFechaCompletaEscritaFromString(revisita[index].fecha)}"),
                        subtitle: Text(revisitita.observaciones),
                      ),
                    ),
                  );
                });
          } else {
            return const CustomError(
              errorMsg:
                  "No se pudo identificar las revisitas asociadas a esta persona.",
              icon: Icons.error,
              color: Colors.red,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.pushNamed(context, "revisitita", arguments: personita),
          label: const Text("Registrar Revisita"),
          icon: const Icon(Icons.add)),
    );
  }
}

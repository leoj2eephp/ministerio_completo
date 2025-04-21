import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/informe.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:ministerio_completo/helpers/fechas.dart' as date_helper;
import 'package:ministerio_completo/helpers/custom_dialogs.dart'
    as custom_dialogs;
import 'package:provider/provider.dart';

class InformeMesScreen extends StatelessWidget {
  final Informe informito;
  const InformeMesScreen({super.key, required this.informito});

  @override
  Widget build(BuildContext context) {
    final registro = Provider.of<DBProvider>(context);
    return Scaffold(
      appBar:
          AppBar(title: Text("Informe del Mes ${informito.getNombreMes()}")),
      body: FutureBuilder(
        future: registro.getActividadMes(informito),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final informes = snapshot.data!;
            return ListView.builder(
              itemCount: informes.length,
              itemBuilder: (context, index) {
                final informito = informes[index];
                return Dismissible(
                  key: Key(informito.id.toString()),
                  onDismissed: (direction) {
                    registro.deleteActividad(informito.id!);
                  },
                  confirmDismiss: (direction) async {
                    return await custom_dialogs.showConfirmDialog(
                        context,
                        "Confirmar eliminación",
                        "¿Estás seguro de que deseas eliminar este elemento?",
                        Icons.delete,
                        Colors.red);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.watch_later_outlined),
                    title: Text(
                      "${date_helper.getDayNameFromString(informito.fecha)} ${informito.fechaFormatoChile}",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      informito.formatoHora,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w100),
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

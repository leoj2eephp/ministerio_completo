import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/informe.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:provider/provider.dart';

class DetalleMesScreen extends StatelessWidget {
  final Informe informito;
  const DetalleMesScreen({super.key, required this.informito});

  @override
  Widget build(BuildContext context) {
    final registro = Provider.of<DBProvider>(context);
    return Scaffold(
      appBar:
          AppBar(title: Text("Informe del Mes ${informito.getNombreMes()}")),
      body: FutureBuilder(
        future: registro.getActividadMes(informito.getMes()),
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
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text("Horas: ${informito.formatoHora}"),
                    subtitle: Text(informito.fecha),
                    trailing: const Icon(Icons.menu),
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

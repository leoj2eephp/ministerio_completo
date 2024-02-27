import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:ministerio_completo/screens/detalle_mes_screen.dart';
import 'package:provider/provider.dart';

class DetalleActividadScreen extends StatelessWidget {
  const DetalleActividadScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    final registro = Provider.of<DBProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Informes de Predicación")),
      body: FutureBuilder(
        future: registro.getActividadAgrupadaPorMes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final informes = snapshot.data!;
            return ListView.builder(
              itemCount: informes.length,
              itemBuilder: (context, index) {
                final informito = informes[index];
                return ListTile(
                  title: Text("Mes de ${informito.getNombreMes()}"),
                  subtitle: Text("Horas: ${informito.formatoHora}"),
                  isThreeLine: true,
                  trailing: const Icon(Icons.menu),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleMesScreen(informito: informito),
                    ),
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

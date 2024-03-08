import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:ministerio_completo/screens/informe_mes_screen.dart';
import 'package:provider/provider.dart';

class ListaInformesScreen extends StatelessWidget {
  const ListaInformesScreen({super.key, BuildContext? context});

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
            if (informes.isNotEmpty) {
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
                            InformeMesScreen(informito: informito),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                      "No hay activida registrada.\nPulsa en el botón en la parte inferior derecha\nde la pantalla para agregar una actividad."));
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, "actividad"),
          label: const Text("Ingresar Actividad"),
          icon: const Icon(Icons.add)),
    );
  }
}

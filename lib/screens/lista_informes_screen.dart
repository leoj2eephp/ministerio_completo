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
              final informesPorAno = <String, List>{};
              for (var informe in informes) {
                final ano = informe.fecha.split('-')[1];
                if (informesPorAno.containsKey(ano)) {
                  informesPorAno[ano]!.add(informe);
                } else {
                  informesPorAno[ano] = [informe];
                }
              }

              return Column(
                children: informesPorAno.keys.map((ano) {
                  return ExpansionTile(
                    title: Text(ano),
                    initiallyExpanded: ano == DateTime.now().year.toString(),
                    backgroundColor: Colors.blue[100],
                    children: informesPorAno[ano]!.map((informe) {
                      return ListTile(
                        title: Text("Mes de ${informe.getNombreMes()}"),
                        subtitle: Text("Horas: ${informe.formatoHora}"),
                        leading: const Icon(Icons.watch_later_outlined),
                        trailing: const Icon(Icons.calendar_month_outlined),
                        minVerticalPadding: double.minPositive,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InformeMesScreen(informito: informe),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
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

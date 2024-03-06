import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:ministerio_completo/widgets/custom_error.dart';
import 'package:ministerio_completo/widgets/simple_persona_list_tile.dart';
import 'package:provider/provider.dart';

class DetalleRevisitaScreen extends StatelessWidget {
  const DetalleRevisitaScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    // final revisitaProvider = Provider.of<RevisitaProvider>(context, listen: false);
    final personaPro = Provider.of<PersonaProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revisitas realizadas"),
      ),
      body: FutureBuilder(
        future: personaPro.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final listaPersonas = snapshot.data!;
            if (listaPersonas.isEmpty) {
              return const CustomError(
                errorMsg:
                    "Debe crear al menos un persona antes de generar un registro de revisita",
                icon: Icons.error_outline,
                color: Colors.orange,
              );
            } else {
              return ListView.builder(
                itemCount: listaPersonas.length,
                itemBuilder: (_, int index) => SimplePersonaListTile(
                  personita: listaPersonas[index],
                  onTap: () => Navigator.pushNamed(context, "lista_revisitas",
                      arguments: listaPersonas[index]),
                ),
              );
            }
          }
          return const CustomError(
            errorMsg: "Hubo un error al cargar la información",
            icon: Icons.warning,
            color: Colors.red,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "revisitita"),
        child: const Icon(Icons.add),
      ),
    );
  }
}

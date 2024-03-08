import 'package:flutter/material.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:ministerio_completo/widgets/custom_error.dart';
import 'package:provider/provider.dart';

class ListaRevisitasScreen extends StatelessWidget {
  const ListaRevisitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revisitaProvider = Provider.of<RevisitaProvider>(context);
    final personita = ModalRoute.of(context)!.settings.arguments as Persona;
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle Revisita realizada")),
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
            return Stack(children: [
              ListView.builder(
                  itemCount: revisita.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text("Fecha: ${revisita[index].fecha}"),
                      subtitle: Text(revisita[index].observaciones),
                    );
                  }),
              Positioned(
                bottom: 20,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () => "",
                      color: Colors.blue,
                      textColor: Colors.white,
                      minWidth: 10,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Row(
                        children: [
                          Text("Agregar Revisita "),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              )
            ]);
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
    );
  }
}

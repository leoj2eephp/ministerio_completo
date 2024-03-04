import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:ministerio_completo/widgets/persona_list_tile.dart';
import 'package:provider/provider.dart';

class DetallePersonaScreen extends StatelessWidget {
  const DetallePersonaScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    final personaProvider = Provider.of<PersonaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Personas Interesadas")),
      body: FutureBuilder(
        future: personaProvider.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final personaList = snapshot.data!;
            return Stack(children: [
              ListView.builder(
                itemCount: personaList.length,
                itemBuilder: (context, index) {
                  final personita = personaList[index];
                  return PersonaListTile(
                    personita: personita,
                    onDismissible: personaProvider.delete,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "personita",
                        arguments: {
                          "personita": personita,
                        },
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () => Navigator.pushNamed(context, "mapa",
                          arguments: {"listaPersonas": personaList}),
                      color: Colors.blue,
                      textColor: Colors.white,
                      minWidth: 10,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Row(
                        children: [
                          Text("Ubicaciones "),
                          Icon(Icons.gps_fixed),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    MaterialButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "personita"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      minWidth: 10,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Row(
                        children: [
                          Text("Persona "),
                          Icon(Icons.add_circle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      /* floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "personita"),
      ), */
    );
  }
}

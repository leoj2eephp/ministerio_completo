import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:provider/provider.dart';

class DetallePersonaScreen extends StatelessWidget {
  const DetallePersonaScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    final personas = Provider.of<PersonaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Personas Interesadas")),
      body: FutureBuilder(
        future: personas.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final personaList = snapshot.data!;
            return Stack(children: [
              ListView.builder(
                itemCount: personaList.length,
                itemBuilder: (context, index) {
                  final personita = personaList[index];
                  return Dismissible(
                    key: Key(personita.id.toString()),
                    onDismissed: (direction) {
                      personas.delete(personita.id!);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Center(child: Text(personita.nombre)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(personita.observaciones),
                          /* Text("Lat: ${personita.lat}"),
                          Text("Lng: ${personita.lng}"), */
                        ],
                      ),
                      trailing: const Icon(Icons.gps_fixed),
                      onTap: () =>
                          Navigator.pushNamed(context, "personita", arguments: {
                        "personita": personita,
                      }),
                    ),
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

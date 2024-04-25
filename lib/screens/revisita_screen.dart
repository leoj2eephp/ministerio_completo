import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ministerio_completo/models/persona.dart';
import 'package:ministerio_completo/providers/navigation_provider.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:ministerio_completo/widgets/date_picker_informe.dart';
import 'package:provider/provider.dart';

class RevisitaScreen extends StatelessWidget {
  const RevisitaScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    final revisitaProvider = Provider.of<RevisitaProvider>(context);
    final navProvider = Provider.of<NavigationProvider>(context);
    final personita = ModalRoute.of(context)?.settings.arguments as Persona?;
    double screenWidth = MediaQuery.of(context).size.width * .92;
    String title = "";
    if (personita != null) {
      title = "Registrar Revisita a ${personita.nombre}";
      revisitaProvider.personaId = personita.id;
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DatePickerInforme(
                      revisitaProvider: revisitaProvider,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      revisitaProvider.observaciones = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  personita == null
                      ? FutureBuilder(
                          future: _loadDropdownMenuEntries(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownMenu(
                                  label: const Text("Seleccione una persona"),
                                  helperText:
                                      "Persona a la que se le registrará una revisita",
                                  width: screenWidth,
                                  enableFilter: true,
                                  enableSearch: true,
                                  onSelected: (value) =>
                                      revisitaProvider.personaId = value,
                                  dropdownMenuEntries: snapshot.data!);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )
                      : const Text(""),
                  const SizedBox(height: 50),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        revisitaProvider.save();
                        navProvider.menu = 3;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add), label: const Text("Guardar"),
                      // color: Theme,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<DropdownMenuEntry<int>>> _loadDropdownMenuEntries(
      BuildContext context) async {
    List<DropdownMenuEntry<int>> menus = [];
    try {
      final provider = Provider.of<PersonaProvider>(context);
      final data = await provider.getAll();
      for (var personita in data) {
        menus.add(DropdownMenuEntry(
          value: personita.id!,
          label: personita.nombre,
        ));
      }
    } catch (e) {
      final Logger logger = Logger();
      logger.e(e);
    }
    return menus;
  }
}

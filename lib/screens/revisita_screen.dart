import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:ministerio_completo/widgets/date_picker_informe.dart';
import 'package:provider/provider.dart';

class RevisitaScreen extends StatelessWidget {
  const RevisitaScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    final revisitaProvider = Provider.of<RevisitaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Revisita")),
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
                    // initialValue: persona?.observaciones ?? "",
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // personaProvider.save();
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
}

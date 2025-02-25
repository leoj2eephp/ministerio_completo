import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:ministerio_completo/providers/registro_actividad_provider.dart';
import 'package:ministerio_completo/widgets/date_picker_informe.dart';
import 'package:ministerio_completo/widgets/time_picker_informe.dart';
import 'package:provider/provider.dart';

enum Tipo { suma, resta }

class ActividadScreen extends StatelessWidget {
  final BuildContext? context;
  const ActividadScreen({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Logger l = Logger();
    final dbProvider = Provider.of<DBProvider>(context, listen: false);
    final registro = Provider.of<RegistroActividadProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Informe del día")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ingresar Actividad",
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DatePickerInforme(
                registroProvider: registro,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimePickerInforme(
                    label: 'Hrs.',
                    timeType: TimeType.hour,
                  ),
                  TimePickerInforme(
                    label: 'Mins.',
                    timeType: TimeType.minute,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final resultado = await dbProvider.insertActividad(registro);
                if (resultado != -1) {
                  // _mostrarDialog(context, registro);
                  registro.limpiarCampos();
                  Navigator.pop(context);
                } else {
                  l.w("NO SE INSERTÓ NADA");
                }
              },
              label: const Text(
                "Guardar",
                style: TextStyle(fontSize: 20),
              ),
              icon: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}

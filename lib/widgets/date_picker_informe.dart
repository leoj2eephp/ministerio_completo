import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/registro_actividad_provider.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';

class DatePickerInforme extends StatelessWidget {
  final RegistroActividadProvider? registroProvider;
  final RevisitaProvider? revisitaProvider;
  const DatePickerInforme(
      {super.key, this.registroProvider, this.revisitaProvider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              final DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (dateTime != null) {
                if (registroProvider != null) {
                  registroProvider!.fecha = dateTime;
                } else {
                  revisitaProvider!.fecha = dateTime;
                }
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: registroProvider != null
                      ? registroProvider!.fechaFormateadaCliente
                      : revisitaProvider!.fechaFormateadaCliente,
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

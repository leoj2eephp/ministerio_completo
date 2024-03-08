import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/registro_actividad_provider.dart';
import 'package:provider/provider.dart';

enum TimeType { hour, minute }

class TimePickerInforme extends StatelessWidget {
  final String label;
  final TimeType timeType;

  const TimePickerInforme(
      {super.key, required this.label, required this.timeType});

  @override
  Widget build(BuildContext context) {
    final registro = Provider.of<RegistroActividadProvider>(context);

    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
        // const SizedBox(height: 10),
        SizedBox(
          height: 200,
          width: 80,
          child: ListWheelScrollView(
            itemExtent: 60,
            diameterRatio: 1,
            offAxisFraction: timeType == TimeType.hour ? -.1 : .1,
            useMagnifier: true,
            magnification: 1.8,
            physics: const FixedExtentScrollPhysics(),
            children: _buildTimeItems(),
            onSelectedItemChanged: (index) => timeType == TimeType.hour
                ? registro.horas = index
                : registro.minutos = index,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            timeType == TimeType.hour
                ? registro.horaFormateada
                : registro.minutosFormateados,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTimeItems() {
    List<Widget> items = [];
    int itemCount = timeType == TimeType.hour ? 24 : 60;

    for (int i = 0; i < itemCount; i++) {
      items.add(
        Center(
          child: Text(
            i.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return items;
  }
}

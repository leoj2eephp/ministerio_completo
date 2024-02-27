import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController =
      TextEditingController(); // Controlador para el campo de texto

  @override
  void initState() {
    super.initState();
    _updateDateText(); // Inicializa el texto del campo de texto
  }

  // Actualiza el texto del campo de texto con la fecha seleccionada
  void _updateDateText() {
    _dateController.text =
        "${selectedDate.day.toString().padLeft(2, '0')} - ${selectedDate.month.toString().padLeft(2, '0')} - ${selectedDate.year}";
  }

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
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (dateTime != null) {
                setState(() {
                  selectedDate = dateTime;
                  _updateDateText(); // Actualiza el texto del campo de texto
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateController,
                style: const TextStyle(
                  fontSize: 20, // Tamaño de fuente personalizado
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

import 'package:flutter/material.dart';

void showImportProgressDialog(BuildContext context, String texto) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20.0),
              Text(texto),
            ],
          ),
        ),
      );
    },
  );
}

void hideImportProgressDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void shoInformationDialog(
    BuildContext context, String texto, IconData icon, Color iconColor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(height: 20.0),
              Text(texto),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool?> showConfirmDialog(BuildContext context, String title,
    String content, IconData icon, Color color) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              "Eliminar Registro",
              style: TextStyle(color: (Colors.red)),
            ),
          ),
        ],
      );
    },
  );
}

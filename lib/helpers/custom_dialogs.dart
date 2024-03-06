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
    BuildContext context, String texto, IconData icon, Color color) {
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
                color: color,
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

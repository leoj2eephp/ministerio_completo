import 'package:flutter/material.dart';

class DetalleRevisitaScreen extends StatelessWidget {
  const DetalleRevisitaScreen({super.key, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    // final revisitaProvider = Provider.of<RevisitaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revisitas realizadas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "revisitita"),
        child: const Icon(Icons.add),
      ),
    );
  }
}

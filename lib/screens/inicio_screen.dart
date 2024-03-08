import 'package:flutter/material.dart';
import 'package:ministerio_completo/helpers/custom_dialogs.dart';
import 'package:ministerio_completo/helpers/export_data_json.dart';
import 'package:ministerio_completo/helpers/import_data_json.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isDarkMode = tema.brightness == Brightness.dark;
    final primaryColor = !isDarkMode ? Theme.of(context).primaryColor : null;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            // color: Colors.blue.shade200,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.cloud_upload, color: primaryColor),
                    Text(" Respaldar", style: TextStyle(color: primaryColor)),
                  ],
                ),
                onTap: () => exportDatabaseToJSON(context),
              ),
              PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.cloud_download, color: primaryColor),
                      Text(" Restaurar", style: TextStyle(color: primaryColor)),
                    ],
                  ),
                  onTap: () {
                    showImportProgressDialog(
                        context, "Sincronizando información");
                    importFile().then((result) {
                      if (result) {
                        hideImportProgressDialog(context);
                        shoInformationDialog(
                            context,
                            "Sincronización finalizada",
                            Icons.check,
                            Colors.green);
                      } else {
                        hideImportProgressDialog(context);
                        shoInformationDialog(
                            context,
                            "Hubo un error al importar la información",
                            Icons.error,
                            Colors.red);
                      }
                    });
                  }),
            ],
          ),
        ],
        title: const Text("Bienvenido"),
      ),
      body: const Center(
        child: Text("INICIO"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ministerio_completo/helpers/custom_dialogs.dart';
import 'package:ministerio_completo/helpers/export_data_json.dart';
import 'package:ministerio_completo/helpers/google_sign_in_helper.dart';
import 'package:ministerio_completo/helpers/import_data_json.dart';
import 'package:ministerio_completo/providers/config_provider.dart';
import 'package:provider/provider.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final signIn = GoogleSignInHelper();
  ConfigProvider? configProvider;
  bool isSignedIn = false;
  bool isSyncActive = false;

  @override
  void initState() {
    super.initState();
    setIsSignedIn();
    if (isSignedIn) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
  }

  Future<void> setIsSignedIn() async {
    isSignedIn = await signIn.isSignedIn();
  }

  Future<void> setIsSyncActive() async {
    final googleAccount = await signIn.signInWithGoogle();
    final authClient = await signIn.getAuthClient(googleAccount);
    if (authClient != null) {
      setState(() {
        isSyncActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isDarkMode = tema.brightness == Brightness.dark;
    final primaryColor = !isDarkMode ? Theme.of(context).primaryColor : null;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Bienvenido"),
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
                  onTap: () => _importDatabaseFromJSON(context)),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.cloud_sync, color: primaryColor),
                    const SizedBox(width: 8),
                    Text("Respaldo automático",
                        style: TextStyle(color: primaryColor)),
                    const Spacer(),
                    Consumer<ConfigProvider>(
                      builder: (context, syncProvider, child) {
                        return Switch(
                          value: syncProvider.isSyncEnabled,
                          onChanged: (value) =>
                              _toggleSync(context, syncProvider, value),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // verifySignIn() ?
            !configProvider!.isSyncEnabled
                ? Card(
                    elevation: 8,
                    color: Colors.orange.shade100,
                    child: ListTile(
                      // leading: const Icon(Icons.warning, color: Colors.orange),
                      title: const Text(
                          "No se ha activado la sincronización automática"),
                      trailing: ElevatedButton(
                          onPressed: () async {
                            final sw = await configProvider!.toggleSync(true);
                            setState(() => isSyncActive = sw);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text("Activar"), Icon(Icons.sync)],
                          )),
                    ),
                  )
                : Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(
                        "La sincroniazción está activada.",
                        style: tema.textTheme.bodyLarge,
                      ),
                      trailing: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
            if (configProvider!.isSyncEnabled)
              Card(
                elevation: 8,
                child: ListTile(
                  title: Text(
                    "Última sincronización: ${configProvider!.lastSyncDateFormatted}",
                    style: tema.textTheme.bodyLarge,
                  ),
                ),
              )
          ],
        ),
      )),
    );
  }

  Future<void> _toggleSync(
      BuildContext context, ConfigProvider syncProvider, bool value) async {
    if (value && configProvider!.isSignIn) {
      if (!mounted) return;
      shoInformationDialog(
          context,
          "Necesita agregar una cuenta de Google a su dispositivo primero.",
          Icons.warning,
          Colors.orange);
    }
    syncProvider.toggleSync(value);
  }

  Future<void> _importDatabaseFromJSON(BuildContext context) async {
    showImportProgressDialog(context, "Sincronizando información");
    final result = await importFile();
    if (result) {
      hideImportProgressDialog(context);
      shoInformationDialog(
          context, "Sincronización finalizada", Icons.check, Colors.green);
    } else {
      if (!mounted) return;
      hideImportProgressDialog(context);
      shoInformationDialog(context, "Hubo un error al importar la información",
          Icons.error, Colors.red);
    }
  }
}

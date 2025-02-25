import 'package:flutter/material.dart';
import 'package:ministerio_completo/helpers/google_drive_helper.dart';
import 'package:ministerio_completo/helpers/google_sign_in_helper.dart';
import 'package:ministerio_completo/providers/config_provider.dart';
import 'package:ministerio_completo/providers/navigation_provider.dart';
import 'package:ministerio_completo/screens/inicio_screen.dart';
import 'package:ministerio_completo/screens/lista_informes_screen.dart';
import 'package:ministerio_completo/screens/lista_personas_revisitadas_screen.dart';
import 'package:ministerio_completo/screens/lista_personas_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final signIn = GoogleSignInHelper();
  bool isSignedIn = false;
  ConfigProvider? configProvider;

  @override
  void initState() {
    super.initState();
    _checkAndSyncData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context);
  }

  Future<void> _checkAndSyncData() async {
    isSignedIn = await signIn.isSignedIn();
    if (isSignedIn && await shouldSyncToday()) {
      final result = await uploadJsonToDrive();
      if (result) {
        configProvider?.updateLastSyncDate();
      }
    }
  }

  Future<bool> shouldSyncToday() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastSync = prefs.getString('last_sync_date');
    String today = DateTime.now().toIso8601String().split('T')[0];
    return lastSync != today;
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final tema = Theme.of(context);
    final isDarkMode = tema.brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => navProvider.menu = value,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: "Informe",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Personas"),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: "Revisitas"),
        ],
        elevation: 10,
        currentIndex: navProvider.menu,
        selectedItemColor: !isDarkMode ? Theme.of(context).primaryColor : null,
        unselectedItemColor:
            !isDarkMode ? Theme.of(context).dividerColor : null,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      body: const _CustomBody(),
    );
  }
}

class _CustomBody extends StatelessWidget {
  const _CustomBody();

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    switch (navProvider.menu) {
      case 0:
        return const InicioScreen();
      case 1:
        return ListaInformesScreen(context: context);
      case 2:
        return ListaPersonasScreen(context: context);
      case 3:
        return ListaPersonasRevisitadasScreen(context: context);
      default:
        return const InicioScreen();
    }
  }
}

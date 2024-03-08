import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/navigation_provider.dart';
import 'package:ministerio_completo/screens/inicio_screen.dart';
import 'package:ministerio_completo/screens/lista_informes_screen.dart';
import 'package:ministerio_completo/screens/lista_personas_revisitadas_screen.dart';
import 'package:ministerio_completo/screens/lista_personas_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

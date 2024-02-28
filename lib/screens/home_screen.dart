import 'package:flutter/material.dart';
import 'package:ministerio_completo/providers/navigation_provider.dart';
import 'package:ministerio_completo/screens/actividad_screen.dart';
import 'package:ministerio_completo/screens/detalle_actividad_screen.dart';
import 'package:ministerio_completo/screens/detalle_persona_screen.dart';
import 'package:ministerio_completo/screens/detalle_revisita_screen.dart';
import 'package:ministerio_completo/screens/inicio_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      /* appBar: AppBar(
        title: const Text("Inicio"),
      ), */
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
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).dividerColor,
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
        return DetalleActividadScreen(context: context);
      case 1:
        return ActividadScreen(context: context);
      case 2:
        return DetallePersonaScreen(context: context);
      case 3:
        return DetalleRevisitaScreen(context: context);
      default:
        return const InicioScreen();
    }
  }
}
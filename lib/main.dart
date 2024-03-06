import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:ministerio_completo/providers/navigation_provider.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:ministerio_completo/providers/registro_actividad_provider.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:ministerio_completo/screens/actividad_screen.dart';
import 'package:ministerio_completo/screens/detalle_actividad_screen.dart';
import 'package:ministerio_completo/screens/detalle_persona_screen.dart';
import 'package:ministerio_completo/screens/detalle_revisita_screen.dart';
import 'package:ministerio_completo/screens/home_screen.dart';
import 'package:ministerio_completo/screens/lista_revisitas_screen.dart';
import 'package:ministerio_completo/screens/mapa_screen.dart';
import 'package:ministerio_completo/screens/personas_screen.dart';
import 'package:ministerio_completo/screens/revisita_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DBProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PersonaProvider()),
        ChangeNotifierProvider(create: (_) => RegistroActividadProvider()),
        ChangeNotifierProvider(create: (_) => RevisitaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ministerio Completo',
        routes: {
          "home": (_) => const HomeScreen(),
          "actividad": (context) => const ActividadScreen(),
          "actividad_anual": (context) => const DetalleActividadScreen(),
          "personas": (_) => const DetallePersonaScreen(),
          "personita": (context) => PersonasScreen(context: context),
          "revisitas": (context) => DetalleRevisitaScreen(context: context),
          "revisitita": (context) => RevisitaScreen(context: context),
          "lista_revisitas": (context) => const ListaRevisitasScreen(),
          // "detalleMes": (_) => const DetalleMesScreen(),
          "mapa": (context) => const MapaScreen(),
          // "mapa": (context) => const MapaScreen2(title: "Mapa"),
        },
        initialRoute: "home",
        /* theme: ThemeData().copyWith(
          primaryColor: Colors.blue,
        ), */
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'CL'),
        ],
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ministerio_completo/providers/config_provider.dart';
import 'package:ministerio_completo/providers/db_provider.dart';
import 'package:ministerio_completo/providers/navigation_provider.dart';
import 'package:ministerio_completo/providers/persona_provider.dart';
import 'package:ministerio_completo/providers/registro_actividad_provider.dart';
import 'package:ministerio_completo/providers/revisita_provider.dart';
import 'package:ministerio_completo/screens/actividad_screen.dart';
import 'package:ministerio_completo/screens/home_screen.dart';
import 'package:ministerio_completo/screens/lista_informes_screen.dart';
import 'package:ministerio_completo/screens/lista_personas_revisitadas_screen.dart';
import 'package:ministerio_completo/screens/lista_personas_screen.dart';
import 'package:ministerio_completo/screens/lista_revisitas_screen.dart';
import 'package:ministerio_completo/screens/mapa_screen.dart';
import 'package:ministerio_completo/screens/personas_screen.dart';
import 'package:ministerio_completo/screens/revisita_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
/*
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  // Configura el servicio
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, // Método que ejecuta el servicio
      isForegroundMode: true,
      autoStart: false, // El servicio no iniciará automáticamente
      notificationChannelId: 'com.leodevs.ministerio_completo',
      initialNotificationTitle: 'Background Service',
      initialNotificationContent: 'El servicio está corriendo',
      foregroundServiceTypes: [AndroidForegroundType.dataSync],
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: (service) async => false,
    ),
  );
}

void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  final config = ConfigProvider();
  await config.loadPreferences();
  if (config.isSyncEnabled) {
    if (await shouldSyncToday()) {
      uploadJsonToDrive().then((_) async {
        final prefs = await SharedPreferences.getInstance();
        String today = DateTime.now().toIso8601String().split('T')[0];
        await prefs.setString('last_sync_date', today);
      });
    }
    // Tarea que se ejecutará en background
    /* Timer.periodic(const Duration(days: 1), (timer) async {
      uploadJsonToDrive();
    }); */
  }
}
*/

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
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ministerio Completo',
        routes: {
          "home": (_) => const HomeScreen(),
          "actividad": (context) => ActividadScreen(context: context),
          "actividad_anual": (context) => const ListaInformesScreen(),
          "personas": (_) => const ListaPersonasScreen(),
          "personita": (context) => PersonasScreen(context: context),
          "revisitas": (context) =>
              ListaPersonasRevisitadasScreen(context: context),
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

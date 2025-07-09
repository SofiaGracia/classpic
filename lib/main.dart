import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/uri_notifier.dart';
import 'package:xml_fotos/presentation/screens/configuration.dart';
import 'package:xml_fotos/presentation/screens/splash.dart';

import 'data/datasources/db/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Inicialitzem la base de dades
  final dbService = DatabaseService();
  await dbService.connectaDB();

  final container = ProviderContainer();
  final uri = await container.read(UriProvider.future); // força el build()
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/config': (context) => ConfigurationScreen()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

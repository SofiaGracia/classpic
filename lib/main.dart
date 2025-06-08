import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml_fotos/presentation/providers/ini.dart';
import 'package:xml_fotos/presentation/screens/error.dart';
import 'package:xml_fotos/presentation/screens/menu_riverpod.dart';
import 'package:xml_fotos/presentation/screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Quan s'inicie l'aplicació crear ja l'estructura per a professors i alumnes
    final initAsync = ref.watch(inicialitzacioProvider);

    return initAsync.when(
      loading: () => const MaterialApp(home: SplashScreen(),debugShowCheckedModeBanner: false),
      error: (e, st) => MaterialApp(home: ErrorScreen()),
      data: (_) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const MenuScreenR(),
      ),
    );
  }
}

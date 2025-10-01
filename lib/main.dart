import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classpic/presentation/providers/db/database.dart';
import 'package:classpic/presentation/providers/uri_notifier.dart';
import 'package:classpic/presentation/screens/configuration.dart';
import 'package:classpic/presentation/screens/splash.dart';
import 'package:classpic/shared/themes/basic_theme.dart';

import 'data/datasources/db/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(UriProvider.future); // force build()

  final db = await DatabaseService().connectDB();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Classpic',
      routes: {'/config': (context) => ConfigurationScreen()},
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),*/
      theme: getTheme(context),
      home: SplashScreen(),
    );
  }
}

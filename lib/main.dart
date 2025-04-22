import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml_fotos/providers/info_xml.dart';
import 'package:xml_fotos/providers/usuaris.dart';
import 'package:xml_fotos/repository/implementations/xml.dart';
import 'package:xml_fotos/repository/interfaces/ixml.dart';
import 'package:xml_fotos/screens/menu.dart';
import 'package:xml_fotos/screens/sessio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      //Provider<IRepositoryCursos>(create: (_) => RepositoryCursos()),
      ChangeNotifierProvider<UsuarisProvider>(create: (_) => UsuarisProvider()),
      // altres providers
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: MenuScreen());
  }
}

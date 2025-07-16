import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:xml_fotos/presentation/screens/menu.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Expanded(
              child: Lottie.asset('assets/json/mostra.json'),
            )
          ],
        ),
        splashIconSize: 400,
        nextScreen: const MenuScreen());
  }
}

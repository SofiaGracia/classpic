import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:xml_fotos/presentation/screens/menu_riverpod.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Center(
              child: LottieBuilder.asset('mostra'),
            )
          ],
        ),
        splashIconSize: 400,
        nextScreen: const MenuScreenR());
  }
}

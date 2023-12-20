import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fit_fighter/screens/main_menu.dart';
import 'package:flutter/material.dart';

class GameSplashScreen extends StatelessWidget {
  const GameSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: Image.asset('assets/images/game_logo.png'),
      nextScreen: const MainMenu(),
      splashIconSize: 250,
      backgroundColor: Colors.black,
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}

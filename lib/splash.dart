import 'package:flutter/material.dart';
import 'package:pi/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key, required String title});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Login(
             
          ),
          transitionDuration:
              const Duration(seconds: 0), // Set duration to zero for no animation
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/back.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

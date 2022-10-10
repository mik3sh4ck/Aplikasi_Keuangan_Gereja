//ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(
          const Duration(seconds: 4),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApp(),
            ),
          ),
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: const Center(
        child: Image(
          image: AssetImage("lib/assets/images/Burung0.3.gif"),
        ),
      ),
    );
  }
}

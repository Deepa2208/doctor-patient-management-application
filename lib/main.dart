import 'package:flutter/material.dart';
import 'rolescreen.dart';

void main() {
  runApp(Dpm());
}

class Dpm extends StatelessWidget {
  const Dpm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Rolescreen());
  }
}

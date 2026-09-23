import 'package:flutter/material.dart';
import 'package:mobile/home-page.dart';

void main() {
  runApp(const Vestory());
}

class Vestory extends StatelessWidget {
  const Vestory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vestory',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

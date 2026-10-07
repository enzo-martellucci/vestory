import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: 12,
          children: [
            Text('Vestory', style: TextStyle(fontSize: 48, fontWeight: .w900)),
            Text('Welcome to our app', style: TextStyle(fontSize: 24, fontWeight: .w500)),
          ],
        ),
      ),
    );
  }
}

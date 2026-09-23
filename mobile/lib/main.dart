import 'package:flutter/material.dart';

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
            Text('Vestory', style: TextStyle(fontSize: 48, fontWeight: .w900),),
            Text('Welcome to our app', style: TextStyle(fontSize: 24, fontWeight: .w500),)
          ],
        )
      ),
    );
  }
}

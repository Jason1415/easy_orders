import 'package:flutter/material.dart';

class WaitronAwaitingScreen extends StatefulWidget {
  const WaitronAwaitingScreen({super.key});

  @override
  State<WaitronAwaitingScreen> createState() => _WaitronAwaitingScreenState();
}

class _WaitronAwaitingScreenState extends State<WaitronAwaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Orders'),
      ),
    );
  }
}

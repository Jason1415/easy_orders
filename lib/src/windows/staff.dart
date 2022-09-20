import 'package:flutter/material.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
            tooltip: 'Back',
          ),
        ],
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Kitchen'),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Waitron'),
            onPressed: () {},
          ),
        ),
      ])),
    );
  }
}

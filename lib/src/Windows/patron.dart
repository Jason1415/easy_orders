import 'package:flutter/material.dart';

class PatronScreen extends StatefulWidget {
  const PatronScreen({super.key});

  @override
  State<PatronScreen> createState() => _PatronScreenState();
}

class _PatronScreenState extends State<PatronScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patron Page'),
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
            child: const Text('TODO FORM'),
            onPressed: () {},
          ),
        ),
      ])),
    );
  }
}

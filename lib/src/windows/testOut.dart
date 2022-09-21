import 'package:flutter/material.dart';
import './patron.dart';
import './staff.dart';

class TestOut extends StatefulWidget {
  final String output;
  const TestOut({super.key, required this.output});

  @override
  State<TestOut> createState() => _TestOutState();
}

class _TestOutState extends State<TestOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.output),
      ),
      body: Center(
          child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.all(25),
              child: MaterialButton(
                child: const Text('Patron'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PatronScreen()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: MaterialButton(
                child: const Text('Staff'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StaffScreen()),
                  );
                },
              ),
            ),
          ])),
    );
  }
}

import 'package:easy_orders/src/windows/newOrder.dart';
import 'package:easy_orders/src/windows/waitronPending.dart';
import 'package:flutter/material.dart';

class WaitronTransitionScreen extends StatefulWidget {
  const WaitronTransitionScreen({super.key});

  @override
  State<WaitronTransitionScreen> createState() =>
      _WaitronTransitionScreenState();
}

class _WaitronTransitionScreenState extends State<WaitronTransitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Orders'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('New Order'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewOrderScreen()),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Awaiting Orders'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewOrderScreen()),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Pending Orders'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WaitronPendingScreen()),
              );
            },
          ),
        ),
      ])),
    );
  }
}

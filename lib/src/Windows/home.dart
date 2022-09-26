import 'package:easy_orders/src/Windows/newOrder.dart';
import 'package:easy_orders/src/windows/staffLogin.dart';
import 'package:flutter/material.dart';
import './patron.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Orders'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        /*Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Patron'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewOrderScreen(isPatronOrder: true)),
              );
            },
          ),
        ),*/
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Staff'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StaffLoginScreen()),
              );
            },
          ),
        ),
      ])),
    );
  }
}

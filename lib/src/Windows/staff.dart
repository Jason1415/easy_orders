import 'package:easy_orders/src/windows/newMenuItem.dart';
import 'package:flutter/material.dart';
import './kitchenLogin.dart';
import './waitronLogin.dart';

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
            child: const Text('Kitchen Login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KitchenLoginScreen()),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: MaterialButton(
            child: const Text('Waitron Login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WaitronLoginScreen()),
              );
            },
          ),
        ),
            Container(
              margin: const EdgeInsets.all(25),
              child: MaterialButton(
                child: const Text('New Menu Item'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewMenuItemScreen()),
                  );
                },
              ),
            ),
      ])),
    );
  }
}

import 'package:flutter/material.dart';
import './patron.dart';
import './staff.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline4!,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Text('Home Page'),
      ),
    );
  }
}
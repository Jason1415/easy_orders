import 'package:flutter/material.dart';
import '../../src/Classes/Request.dart';
import '../../src/windows/newRequest.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _requests = <Request>{};
  int _counter = 0;

  void _doClick() {
    setState(() {
      _counter++;
      items.add(CounterRow(_counter));
    });
  }

  List<Widget> items = [
    Text('You have pushed the button this many times:'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
            tooltip: 'Back',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Table No.',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            height: 300,
            child: Builder(
              builder: (context) => Center(child: MyDialog()),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Submit Order'),
          )
        ],
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({super.key});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      items.add(Request('pizza', 'no ham', 2));
    });
  }

  List<Widget> items = [Text('Requests')];

  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items,
              ),
            ),
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewRequestScreen()),
                  );
                },
                child: Text('Add Request'),
                //onPressed: _incrementCounter
            )
          ]),
    );
  }
}

class CounterRow extends StatelessWidget {
  final int count;

  CounterRow(this.count);

  Widget build(BuildContext context) {
    return Text('$count', style: Theme.of(context).textTheme.headline4);
  }
}

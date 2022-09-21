import 'package:flutter/material.dart';
import '../../src/Classes/Request.dart';
import './newOrder.dart';
import './testOut.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Request'),
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
              hintText: 'Select Item',
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
            child: const Text('Add Request'),
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
  List<Widget> notes = [Text('Notes')];
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: notes,
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () async { _awaitNote(context);},
              child: Text('Add Note'),
              //onPressed: _incrementCounter
            )
          ]),
    );
  }

  void _awaitNote(BuildContext context) async {
    String note = '';
    final myController = TextEditingController();
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Center(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: myController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Note',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, myController.text);
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    setState(() {
      notes.add(NotesRow(result));
    });
  }
}

class CounterRow extends StatelessWidget {
  final int count;

  CounterRow(this.count);

  Widget build(BuildContext context) {
    return Text('$count', style: Theme.of(context).textTheme.headline4);
  }
}

class NotesRow extends StatelessWidget {
  final String note;

  const NotesRow(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(note);
  }
}
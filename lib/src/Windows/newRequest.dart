import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../src/Classes/Request.dart';
import '../Classes/MenuIten.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  List<Widget> notes = [const Text('Notes')];
  List<String> notesStrings = [];
  late menuItem itemToAdd;
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('items');
  List<Widget> menuWidgets = [];
  List<menuItem> menuItems = [];
  String dropdownValue = 'Menu Item';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
                onPressed: () async {
                  _awaitItem(context);
                },
                child: const Text('Select Item')),
          ),
          /*DropdownButton<String>(
            selectedItemBuilder: _getListBuilder(),
            onTap: () async {
              _awaitItem(context);
            },
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
          ),*/
          TextFormField(
            controller: myController2,
            decoration: const InputDecoration(
              hintText: 'Count',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Builder(
            builder: (context) {
              return Center(
                  child: MyDialog(notes: notes, notesStrings: notesStrings));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    Request(itemToAdd.description, notesStrings.join(";"),
                        int.parse(myController2.text)));
              },
              child: const Text('Add Request'),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getdropdownList() {
    List<DropdownMenuItem<String>> dropItems = [
      const DropdownMenuItem(
        value: 'Menu Item',
        child: Text('Menu Item'),
      )
    ];
    for (int i = 0; i < menuItems.length; i++) {
      dropItems.add(DropdownMenuItem(
        value: '$i',
        child: Text(menuItems[i].description),
      ));
    }
    return dropItems;
  }

  /*List<DropdownMenuItem<String>> _getListBuilder(){

  }*/

  void _awaitItem(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: StreamBuilder(
            stream: starCountRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return resultsToOrders(snapshot.data?.snapshot.value);
              }
              return Column();
            },
          ),
        ),
      ),
    );
  }

  Widget resultsToOrders(dynamic json) {
    dynamic mItems = json;
    int len = (mItems as Map<dynamic, dynamic>).length;

    List<menuItem> mitems = [];

    for (int i = 0; i < len; i++) {
      String code = mItems['item$i']['code'];
      String description = mItems['item$i']['description'];
      double price = (mItems['item$i']['price']) * 1.0;
      mitems.add(menuItem(code, description, price));
    }

    menuItems = mitems;

    menuWidgets = [];
    for (int i = 0; i < menuItems.length; i++) {
      menuWidgets.add(ItemContainer(item: menuItems[i], callback: _setItem));
    }
    if (menuWidgets.isEmpty) {
      return Column();
    }

    return Column(
      children: menuWidgets,
    );
  }

  void _setItem(menuItem itm) {
    itemToAdd = itm;
    Navigator.pop(context);
  }
}

class MyDialog extends StatefulWidget {
  final List<Widget> notes;
  final List<String> notesStrings;

  const MyDialog({super.key, required this.notes, required this.notesStrings});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.notes,
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () async {
                _awaitNote(context);
              },
              child: const Text('Add Note'),
              //onPressed: _incrementCounter
            )
          ]),
    );
  }

  void _awaitNote(BuildContext context) async {
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
      widget.notes.add(NotesRow(
        result,
        notes: widget.notes,
        noteStrings: widget.notesStrings,
        callback: _removeNote,
      ));
      widget.notesStrings.add(result);
    });
  }

  void _removeNote(String note) {
    setState(() {
      for (int i = 0; i < widget.notesStrings.length; i++) {
        if (widget.notesStrings[i] == note) {
          widget.notesStrings.removeAt(i);
          widget.notes.removeAt(i + 1);
        }
      }
    });
  }
}

class CounterRow extends StatelessWidget {
  final int count;

  const CounterRow(this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$count', style: Theme.of(context).textTheme.headline4);
  }
}

class NotesRow extends StatefulWidget {
  final String note;
  final List<Widget> notes;
  final List<String> noteStrings;
  final void Function(String) callback;

  const NotesRow(this.note,
      {super.key,
      required this.notes,
      required this.noteStrings,
      required this.callback});

  @override
  State<NotesRow> createState() => _NotesRowState();
}

class _NotesRowState extends State<NotesRow> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(20, 50, 50, 50),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 20,
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(widget.note),
                ),
              ),
              Container(
                height: 5,
              ),
            ],
          ),
        ),
        onTap: () async {
          _showDialogue(context);
        },
      ),
    );
  }

  void _showDialogue(BuildContext context) async {
    bool result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                const Text('Delete Note'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result) {
      widget.callback(widget.note);
    }
  }
}

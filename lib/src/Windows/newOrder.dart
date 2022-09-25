import 'package:flutter/material.dart';
import '../../src/Classes/Request.dart';
import '../../src/windows/newRequest.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  List<Widget> orderListItems = [const Text('Requests')];
  List<Request> requests = [];

  final myController = TextEditingController();
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
            controller: myController,
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
          SizedBox(
            child: Builder(
              builder: (context) => Center(
                  child:
                      MyDialog(listItems: orderListItems, requests: requests)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                if (myController.text.isNotEmpty &&
                    int.tryParse(myController.text) != null) {
                  if (requests.isNotEmpty) {
                    submitOrder();
                    Navigator.pop(context);
                  } else {
                    //TODO empty request
                  }
                } else {
                  //TODO empty or invalid table number
                }
              },
              child: const Text('Submit Order'),
            ),
          )
        ],
      ),
    );
  }

  void submitOrder() async {
    String tableNo = myController.text;
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref();
    String s = '{"tableno":"$tableNo","status":"Placed","requests":{';

    for (int i = 0; i < requests.length; i++) {
      s += '"$i":';
      s += jsonEncode(requests[i]);
      if (requests.length > 1 && requests.length - i > 1) {
        s += ',';
      }
    }
    s += '}}';

    int idNo = await getAllWidgets(starCountRef);
    //int idNo = 0;

    String id = 'order$idNo';
    final body = jsonDecode(s);
    DatabaseReference ref = FirebaseDatabase.instance.ref('orders/$id');
    await ref.set(body);
  }

  Future getAllWidgets(DatabaseReference starCountRef) async {
    final snapshot = await starCountRef.get();
    if (snapshot.exists) {
      if ((snapshot.value as dynamic)['orders'] == null) return 0;
      return ((snapshot.value as dynamic)['orders'] as Map<dynamic, dynamic>)
          .length;
    } else {
      return 0;
    }
  }
}

class MyDialog extends StatefulWidget {
  List<Widget> listItems;
  List<Request> requests;
  MyDialog({super.key, required this.listItems, required this.requests});
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
                children: widget.listItems,
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                _addRequest(context);
              },
              child: const Text('Add Request'),
              //onPressed: _incrementCounter
            )
          ]),
    );
  }

  Future<void> _addRequest(BuildContext context) async {
    final Request result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewRequestScreen()),
    );
    if (!mounted) return;

    setState(() {
      widget.listItems.add(result.newOrderLayout(context));
      widget.requests.add(result);
    });
  }

  void _removeRequest(String note) {

  }
}
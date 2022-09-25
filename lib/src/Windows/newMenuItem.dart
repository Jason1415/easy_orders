import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NewMenuItemScreen extends StatefulWidget {
  const NewMenuItemScreen({super.key});

  @override
  State<NewMenuItemScreen> createState() => _NewMenuItemScreenState();
}

class _NewMenuItemScreenState extends State<NewMenuItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Menu Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
            tooltip: 'Back',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: codeController,
              decoration: const InputDecoration(
                hintText: 'Code',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: 'Price',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    _submitItem();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getAllWidgets(DatabaseReference starCountRef) async {
    final snapshot = await starCountRef.get();
    if (snapshot.exists) {
      return ((snapshot.value as dynamic) as Map<dynamic, dynamic>).length;
    } else {
      return 0;
    }
  }

  void _submitItem() async {
    String s =
        '{"code":"${codeController.text}","description":"${descController.text}","price":${priceController.text}}';

    final body = jsonDecode(s);
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('items');
    int idNo = await getAllWidgets(starCountRef);
    DatabaseReference ref = FirebaseDatabase.instance.ref('items/item$idNo');
    await ref.set(body);
  }
}

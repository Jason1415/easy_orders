import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  final String item;
  final String notes;
  final int quantity;
  late Request thisReq;
  late void Function(Request) callback;

  Request(this.item, this.notes, this.quantity);

  Widget newOrderLayout(BuildContext context, Function(Request) callback, Request r) {
    thisReq = r;
    this.callback = callback;
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
                  child: Text('$quantity $item'),
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
      callback(thisReq);
    }
  }

  Widget build(BuildContext context) {
    List<String> noteList = notes.split(';');
    return Builder(
      builder: (context) {
        if (notes == '') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 20,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Text('-> $quantity $item'),
          );
        }
        return Container(

          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('-> $quantity $item'),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [for (String s in noteList) Text('\t\t\t\t\t$s')],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  factory Request.fromJson(dynamic json) {
    return Request(
        json[''] as String, json['notes'] as String, json['quantity'] as int);
  }

  Map toJson() => {"item": item, "notes": notes, "quantity": quantity};
}

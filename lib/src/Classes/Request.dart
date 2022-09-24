import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  final String item;
  final String notes;
  final int quantity;

  Request(this.item, this.notes, this.quantity);

  Widget newOrderLayout(BuildContext context) {
    return Text('$quantity $item');
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

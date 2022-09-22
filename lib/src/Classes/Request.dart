import 'package:flutter/cupertino.dart';

class Request extends StatelessWidget {
  final String item;
  final String notes;
  final int quantity;

  Request(this.item, this.notes, this.quantity);

  Widget build(BuildContext context) {
    List<String> noteList = notes.split(';');
    return Builder(builder: (context) {
      if (notes == '') {
        return Text('$quantity $item');

      }
      return Column(
        children: [
          Text('$quantity $item'),
          Column(
            children: [for (String s in noteList) Text(s)],
          ),
        ],
      );
    },);
  }

  factory Request.fromJson(dynamic json) {
    return Request(json[''] as String, json['notes'] as String, json['quantity'] as int);
  }

  Map toJson() => {
    "item": item,
    "notes":notes,
    "quantity":quantity
  };
}
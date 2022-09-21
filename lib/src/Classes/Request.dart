import 'package:flutter/cupertino.dart';

class Request extends StatelessWidget {
  final String item;
  final String notes;
  final int quantity;

  Request(this.item, this.notes, this.quantity);

  Widget build(BuildContext context) {
    return Text('$quantity $item');
  }
}
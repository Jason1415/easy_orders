import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class menuItem extends StatelessWidget {
  String code;
  String description;
  double price;

  menuItem(this.code, this.description, this.price);

  dynamic _getItemJson() {
    String s = '';
    return jsonDecode(s);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(20, 50, 50, 50),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text('$description ($code)'),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(20, 50, 50, 50),
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text('$price'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemContainer extends StatefulWidget {
  menuItem item;
  final void Function(menuItem) callback;

  ItemContainer({
    super.key,
    required this.item,
    required this.callback,
  });

  @override
  State<ItemContainer> createState() => _itemContainerState();
}

class _itemContainerState extends State<ItemContainer> {
  List<Widget> reqWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Material(
        child: InkWell(
          child: widget.item,
          onTap: () {
            widget.callback(widget.item);
          },
        ),
      ),
    );
  }
}

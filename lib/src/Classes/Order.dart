import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Request.dart';

class OrderContainer extends StatefulWidget {
  final void Function(Order) callback;
  final Order order;
  List<Order> orderList;
  List<Widget> orderWidgets;
  bool hasPermissions;

  OrderContainer(
      {super.key,
      required this.order,
      required this.orderList,
      required this.orderWidgets,
      required this.callback,
      required this.hasPermissions});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  List<Widget> reqWidgets = [];

  @override
  Widget build(BuildContext context) {
    reqWidgets = [];
    _populateRqestWidgets();

    return Material(
      child: InkWell(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          //height: 150,
          child: widget.order.build(context),
        ),
        onTap: () async {
          String stat = getStatus(widget.order.status);
          if (stat != 'Error') {
            if (stat == 'Delivered') {
              if (widget.hasPermissions) {
                showDialogue(context);
              }
            } else {
              showDialogue(context);
            }
          }
        },
      ),
    );
  }

  void _populateRqestWidgets() {
    for (Request r in widget.order.requests) {
      reqWidgets.add(r);
    }
  }

  void showDialogue(BuildContext context) async {
    String status = widget.order.status;
    String nextStatus = getStatus(status);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Promote to $nextStatus'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _promoteStatus(context);
                      Navigator.pop(context);
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
  }

  String getStatus(String s) {
    switch (s) {
      case 'Placed':
        return 'In Progress';

      case 'In Progress':
        return 'Completed';

      case 'Completed':
        return 'Delivered';

      default:
        return 'Error';
    }
  }

  void _promoteStatus(BuildContext context) {
    setState(() {
      String s = widget.order.status;
      switch (s) {
        case 'Placed':
          widget.order.status = 'In Progress';
          widget.callback(widget.order);
          break;

        case 'In Progress':
          widget.order.status = 'Completed';
          widget.callback(widget.order);
          break;

        case 'Completed':
          widget.order.status = 'Delivered';
          widget.callback(widget.order);
          break;

        default:
          widget.order.status = 'Error';
          break;
      }
    });
  }
}

class Order {
  final String tableNo;
  String status;
  final List<Request> requests;
  List<Widget> reqWidgets = [];

  Order(this.tableNo, this.status, this.requests);

  String reqstoJson() {
    String jsonreqs = jsonEncode(requests);
    return jsonreqs;
  }

  Widget build(BuildContext context) {
    reqWidgets = [];
    for (Request r in requests) {
      reqWidgets.add(r);
    }
    return Container(
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(20, 50, 50, 50),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 20,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text('Table $tableNo'),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text(status),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text('${requests.length} Request(s)'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: reqWidgets,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 5,
          ),
        ],
      ),
    );
  }
}

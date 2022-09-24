import 'package:flutter/material.dart';
import '../../src/Classes/Request.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Widget> orderWidgets = [];
  List<Order> orderItems = [];
  bool hasRefreshed = false;
  bool initialized = false;
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
            tooltip: 'Back',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
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
    dynamic orders = json;
    int len = (orders as Map<dynamic, dynamic>).length;
    List<Request> reqs = [];
    List<Order> ords = [];

    for (int i = 0; i < len; i++) {
      reqs = [];
      int tableno = int.parse(orders['order$i']['tableno']);
      String status = orders['order$i']['status'];

      if (status == 'draft') {
        status = 'placed';
      }
      dynamic req = orders['order$i']['requests'];
      int len2 = (req as List).length;
      for (int j = 0; j < len2; j++) {
        dynamic tempReq = req[j];
        reqs.add(
            Request(tempReq['item'], tempReq['notes'], tempReq['quantity']));
      }
      ords.add(Order('$tableno', status, reqs));
    }
    orderItems = ords;

    orderWidgets = [];
    for (int i = 0; i < orderItems.length; i++) {
      orderWidgets.add(OrderContainer(
        order: orderItems[i],
        orderList: orderItems,
        orderWidgets: orderWidgets,
        callback: _refreshOrders,
        hasPermissions: false,
      ));
      orderWidgets.add(const SizedBox(height: 10));
    }
    if (orderWidgets.isEmpty) {
      return Column();
    }

    return Column(
      children: orderWidgets,
    );
  }

  /*
  void _printOrderList(List<Order> l2p) {
    print('List-----');
    if (l2p.length == 0) {
      print('empty');
      print('-------');
      return;
    }
    for(int i = 0; i < l2p.length; i++) {

      print('\tTable ${l2p[i].tableNo}, ${l2p[i].requests.length} Requests');
      if (l2p[i].requests.length != 0) {
        for(int j = 0; j < l2p[i].requests.length; j++) {
          print('\t\t${l2p[i].requests[j].quantity} ${l2p[i].requests[j].item}');
        }
      }
    }
    print('-------');
  }*/

  void _refreshOrders(Order ord) {
    int index = -1;
    for (int i = 0; i < orderItems.length; i++) {
      if (orderItems[i] == ord) {
        index = i;
      }
    }
    if (index == -1) {
    } else {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('orders/order$index');
      ref.set(buildJson(ord));
    }
  }

  dynamic buildJson(Order ordr) {
    String tableNo = ordr.tableNo;
    String s = '{"tableno":"$tableNo","status":"${ordr.status}","requests":{';

    for (int i = 0; i < ordr.requests.length; i++) {
      s += '"$i":';
      s += jsonEncode(ordr.requests[i]);
      if (ordr.requests.length > 1 && ordr.requests.length - i > 1) {
        s += ',';
      }
    }
    s += '}}';
    return jsonDecode(s);
  }
}

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

  factory Order.fromJson(dynamic json) {
    if (json['requests'] != null) {
      var tagObjsJson = json['requests'] as List;
      List<Request> tags =
          tagObjsJson.map((tagJson) => Request.fromJson(tagJson)).toList();
      return Order(json['tableno'] as String, json['status'] as String, tags);
    } else {
      return Order(json['tableno'] as String, json['status'] as String, []);
    }
  }

  Widget build(BuildContext context) {
    reqWidgets = [];
    for (Request r in requests) {
      reqWidgets.add(r);
    }
    return Container(
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
    );
  }
}

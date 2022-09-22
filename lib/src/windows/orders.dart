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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Widget> orderWidgets = [];
  List<Order> orderItems = [];
  bool hasRefreshed = false;
  bool initialized = false;
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    getWidgets();

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
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: orderWidgets,
          ),
        ),
      ),
    );
  }

  void getAllWidgets() async {
    final snapshot = await starCountRef.get();
    if (snapshot.exists) {
      resultsToOrders(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  void getWidgets() async {
    if (!initialized) {
      initialized = true;
      starCountRef.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        resultsToOrders(data);
        print('refresh');
      });
    }

    if (!hasRefreshed) {
      hasRefreshed = true;
      getAllWidgets();
      print('refresh 2');
    }
  }

  void resultsToOrders(dynamic json) {
    dynamic orders = json['orders'];
    int len = (orders as Map<dynamic, dynamic>).length;
    List<Request> reqs = [];
    List<Order> ords = [];

    for (int i = 0; i < len; i++) {
      reqs = [];
      int tableno = int.parse(orders['order$i']['tableno']);
      String status = orders['order$i']['status'];
      if (status == 'draft') {
        status = 'placed';
        print('was draft');
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

    setState(() {
      orderWidgets = [];
      for (int i = 0; i < orderItems.length; i++) {
        orderWidgets.add(OrderContainer(
          order: orderItems[i],
          orderList: orderItems,
          orderWidgets: orderWidgets,
        ));
      }
    });
  }

  String buildJson(Order ordr) {
    return '';
  }
}

class OrderContainer extends StatefulWidget {
  final Order order;
  List<Order> orderList;
  List<Widget> orderWidgets;
  OrderContainer(
      {super.key,
      required this.order,
      required this.orderList,
      required this.orderWidgets});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  List<Widget> reqWidgets = [];

  @override
  Widget build(BuildContext context) {
    reqWidgets = [];
    int orderCount = widget.order.requests.length;
    String tableNo = widget.order.tableNo;
    String status = widget.order.status;
    _populateRqestWidgets();

    return Material(
      child: InkWell(
        child: Container(
          height: 150,
          child: widget.order.build(context),
        ),
        onTap: () async {
          showDialogue(context);
        },
      ),
    );
  }

  void _refreshOrders(Order ord) {

    setState(() {
      widget.orderList.remove(ord);
      widget.orderWidgets = [];
      for (int i = 0; i < widget.orderList.length; i++) {
        widget.orderWidgets.add(OrderContainer(
          order: widget.orderList[i],
          orderList: widget.orderList,
          orderWidgets: widget.orderWidgets,
        ));
      }
    });
  }

  void _populateRqestWidgets() {
    for (Request r in widget.order.requests) {
      reqWidgets.add(r);
    }
  }

  void showDialogue(BuildContext context) async {
    String status = widget.order.status;
    String nextStatus = getStatus(status);
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Text('Promote to $nextStatus'),
              ),
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
    );
  }

  String getStatus(String s) {
    switch (s) {
      case 'placed':
        return 'In Progress';

      case 'In Progress':
        return 'Completed';

      default:
        return 'Error';
    }
  }

  void _promoteStatus(BuildContext context) {
    setState(() {
      String s = widget.order.status;
      switch (s) {
        case 'placed':
          widget.order.status = 'In Progress';
          break;

        case 'In Progress':
          widget.order.status = 'Completed';
          _refreshOrders(widget.order);
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
      List<Request> _tags =
          tagObjsJson.map((tagJson) => Request.fromJson(tagJson)).toList();
      return Order(json['tableno'] as String, json['status'] as String, _tags);
    } else {
      return Order(json['tableno'] as String, json['status'] as String, []);
    }
  }

  @override
  Widget build(BuildContext context) {
    reqWidgets = [];
    for (Request r in requests) {
      reqWidgets.add(r);
    }
    return Column(
      children: [
        Text('Table $tableNo'),
        Builder(
          builder: (context) {
            if (requests.length > 0) {
              return Column(
                children: [
                  Text(status),
                  Text('Requests'),
                  Column(
                    children: reqWidgets,
                  ),
                ],
              );
            }
            return Text(status);
          },
        ),
      ],
    );
  }
}

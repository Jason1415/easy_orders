import 'dart:convert';
import 'package:flutter/material.dart';
import '../../src/Classes/Request.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Classes/Order.dart';

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

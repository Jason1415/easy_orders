import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Classes/Order.dart';
import '../Classes/Request.dart';

class WaitronPendingScreen extends StatefulWidget {
  const WaitronPendingScreen({super.key});

  @override
  State<WaitronPendingScreen> createState() => _WaitronPendingScreenState();
}

class _WaitronPendingScreenState extends State<WaitronPendingScreen> {
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('orders');
  List<Widget> orderWidgets = [];
  List<Order> orderItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
      if (orderItems[i].status != 'Completed') {
        continue;
      }
      orderWidgets.add(OrderContainer(
        order: orderItems[i],
        orderList: orderItems,
        orderWidgets: orderWidgets,
        callback: _refreshOrders,
        hasPermissions: true,
      ));
    }
    if (orderWidgets.isEmpty) {
      return Column();
    }
    return Column(
      children: orderWidgets,
    );
  }

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

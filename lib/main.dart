// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import './src/windows/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import './src/windows/orders.dart';
import './src/Classes/Request.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    //_additem(ref);

    return const MaterialApp(
      title: 'Easy Orders',
      // MaterialApp contains our top-level Navigator
      home:  HomeScreen(),
    );
  }

  void _additem(DatabaseReference ref) async {

    Request r = Request('Peperoni pizza', 'extra peperoni', 2);
    Request q = Request('Meat lovers pizza', 'no ham;extra mushroom', 2);
    var reqs = <Request>[];
    reqs.add(r);
    reqs.add(q);
    Order testOrder = Order('2', 'draft', reqs);
    String s = jsonEncode(testOrder).replaceAll(RegExp(r'[\\]+'), '');
    s = s.replaceAll(r'"Requests":"[{', "\"Requests\":{");
    s = s.replaceAll(r'}},', "},");
    s = s.replaceAll(r'}}]"', "}}");
    s = s.replaceAll(r'},{', "},");
    //debugPrint(s);
    String id = 'New Order 2';

    DatabaseReference ref = FirebaseDatabase.instance.ref('orders/$id');
    /*await ref.set(
      s
    );*/
  }
}

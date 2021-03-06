import 'package:flutter/material.dart';
import 'package:my_custom_alarm/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Custom Alarm',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,      // debug νμ λκΈ°
      home: const MyHomePage(title: 'alarm'),
    );
  }
}


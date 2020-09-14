import 'package:flutter/material.dart';
import 'package:mobile/history.dart';
import 'package:mobile/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Geo locator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/history': (BuildContext context) => History(),
      },
    );
  }
}

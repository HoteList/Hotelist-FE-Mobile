import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoteList',
      home: HomeScreen(),
    );
  }
}

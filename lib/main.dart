import 'package:flutter/material.dart';

void main() => runApp(const MapsApp());

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: const Center(child: Text('Map')),
        ),
      ),
    );
  }
}

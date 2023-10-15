import 'package:flutter/material.dart';

import 'package:maps/screens/screens.dart';

void main() => runApp(const MapsApp());

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Maps',
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

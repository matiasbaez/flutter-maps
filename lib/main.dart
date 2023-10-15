import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps/screens/screens.dart';
import 'package:maps/blocs/blocs.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GpsBloc(),
        ),
      ],
      child: const MapsApp(),
    )
  );
}

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

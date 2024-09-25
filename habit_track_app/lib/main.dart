// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'screens/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(colorScheme: ColorScheme(
          brightness: MediaQuery.platformBrightnessOf(context), 
          primary: Colors.deepPurple[600]!,
          onPrimary: Colors.white, 
          secondary: Colors.deepPurpleAccent,  
          onSecondary: Colors.white, 
          error: Colors.white, 
          onError: Colors.red,
          background: Colors.grey[300]!, 
          onBackground: Colors.grey[800]!, 
          surface: Colors.white, 
          onSurface: Colors.grey[800]!
        )
      ),
      home: const MyHomePage(title: 'Habit Tracker :)'),
    );
  }
}

import 'package:colonyikisifir/home.dart';
import 'package:colonyikisifir/login.dart';
import 'package:colonyikisifir/splashScreen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Colony 2.0',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        "/": (context) => const SplashScreen(),
        "/login" : (context) => const LoginPage(),
        "/home" : (context) => const HomePage(),
        },
    );
  }
}

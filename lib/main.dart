import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CampusEventExplorerApp());
}

class CampusEventExplorerApp extends StatelessWidget {
  const CampusEventExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESTÜ Event Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5B99),
          primary: const Color(0xFF1E5B99),
          secondary: const Color(0xFFB31B1B),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        useMaterial3: true,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A2530),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

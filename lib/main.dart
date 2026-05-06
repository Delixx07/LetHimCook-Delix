import 'package:flutter/material.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(const ChefPintarApp());
}

class ChefPintarApp extends StatelessWidget {
  const ChefPintarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefPintar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF203A56),
        scaffoldBackgroundColor: const Color(0xFF203A56),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF203A56),
          secondary: Color(0xFF587893),
          tertiary: Color(0xFF95CED3),
          surface: Color(0xFF203A56),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF203A56),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF98F6CD),
            foregroundColor: const Color(0xFF203A56),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF95CED3),
          deleteIconColor: const Color(0xFF203A56),
          labelStyle: const TextStyle(
            color: Color(0xFF203A56),
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF587893),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        useMaterial3: true,
      ),
      home: const InputScreen(),
    );
  }
}

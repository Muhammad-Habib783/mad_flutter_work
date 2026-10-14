import 'package:flutter/material.dart';
import 'Landing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Aesthetic Color Scheme: Teal/Mint Blue
    const Color primaryColor = Color(0xFF00A8A8);
    const Color backgroundColor = Color(0xFFF5F7FA); // Very light grey/blue

    return MaterialApp(
      title: 'Flutter Login Demo',
      // Hides the red DEBUG banner on every page of the app
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: primaryColor,
        ),
        // Aesthetic Input Decoration styling
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
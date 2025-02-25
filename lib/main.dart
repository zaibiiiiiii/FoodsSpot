import 'package:flutter/material.dart';
import 'package:foodsspot/Screens/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Food Spot',
      theme: _buildAppTheme(),
      home:  HomePage(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      // useMaterial3: true, // Enables Material 3 design
      // colorScheme: ColorScheme(
      //   brightness: Brightness.dark,
      //   primary: Color(0xFF1E552B), // Primary color
      //   onPrimary: x  .black, // Text color on primary
      //   secondary: Color(0xFF1E552B), // Secondary color
      //   onSecondary: Colors.white, // Text color on secondary
      //   background: Color(0xFF1E1D23), // Scaffold background
      //   onBackground: Colors.white, // Text color on background
      //   surface: Color(0xFF2A2A36), // Card background
      //   onSurface: Colors.white, // Text color on surface
      //   error: Colors.red, // Error color
      //   onError: Colors.white, // Text color on error
      // ),
      //
      // scaffoldBackgroundColor: Color(0xFF1E1D23), // Scaffold background color
      // // Typography: Adjusted for a premium feel
      // textTheme: TextTheme(
      //   displayLarge: TextStyle(
      //     fontSize: 32.0,
      //     fontWeight: FontWeight.bold,
      //     color: Color(0xFFFB8C00), // Primary color for display text
      //   ),
      //   titleLarge: TextStyle(
      //     fontSize: 24.0,
      //     fontWeight: FontWeight.w600,
      //     color: Colors.black,
      //   ),
      //   bodyLarge: TextStyle(
      //     fontSize: 16.0,
      //     fontWeight: FontWeight.normal,
      //     color: Colors.black,
      //   ),
      //   bodySmall: TextStyle(
      //     fontSize: 14.0,
      //     fontWeight: FontWeight.normal,
      //     color: Colors.grey.shade800, // Light gray for smaller text
      //   ),
      //   labelLarge: TextStyle(
      //     fontSize: 16.0,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.black,
      //   ),
      // ),
      //
      // // Elevated Button Theme: Adjusted for consistency with primary color
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Color(0xFFFB8C00), // Primary button color
      //     foregroundColor: Colors.black, // Button text color
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12.0),
      //     ),
      //     padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      //   ),
      // ),
      //
      // // AppBar Theme: Sleek and modern app bar
      // appBarTheme: AppBarTheme(
      //   backgroundColor: Colors.white, // Dark background for AppBar
      //   elevation: 0, // No shadow for a flat design
      //   centerTitle: true, // Center the title in the AppBar
      //   iconTheme: IconThemeData(color: Colors.black), // White icons
      //   titleTextStyle: TextStyle(
      //     fontSize: 22.0,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      // ),
      //
      // // Card Theme: Modern card styling with subtle shadows
      // cardTheme: CardTheme(
      //   color: Color(0xFF2A2A36), // Surface color for cards
      //   elevation: 8.0,
      //   shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // ),
      //
      // // Input Decoration Theme: Clean input fields with custom border colors
      //
      //
      // // Floating Action Button Theme
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: Color(0xFFFB8C00), // Floating button color
      //   foregroundColor: Colors.black, // Icon color in floating button
      //   elevation: 6.0, // Button shadow
      // ),
    );
  }
}




// File: lib/app.dart (UPDATED)
import 'package:flutter/material.dart';
import 'package:ventify_app/constants/colors.dart'; // 🚨 Kailangan ang import!
import 'package:ventify_app/features/dashboard/presentation/dashboard_screen.dart';
// ...

class VentifyApp extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...
      theme: ThemeData(
        // 🚨 NEW THEME SETUP
        primaryColor: VentifyColors.primary,
        scaffoldBackgroundColor:
            VentifyColors.background, // Gamitin ang background color
        appBarTheme: AppBarTheme(
          backgroundColor: VentifyColors.primary, // Default AppBar color
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: VentifyColors.primary,
          // Gamitin ang primary at secondary colors para sa buong theme
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

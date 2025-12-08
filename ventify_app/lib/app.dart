// File: lib/app.dart
import 'package:flutter/material.dart';
import 'package:ventify_app/features/chat/presentation/chat_screen.dart'; // ✅ FIXED PATH
// 🚨 IDAGDAG ITO: Import ang bagong Dashboard Screen
import 'package:ventify_app/features/dashboard/presentation/dashboard_screen.dart';

class VentifyApp extends StatelessWidget {
  const VentifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ventify',
      theme: ThemeData(
        // Ginamit natin ang blue na kulay na napili mo
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0056D2)),
        useMaterial3: true,
      ),
      // Ang home screen natin ay nasa bagong pwesto
      home: const DashboardScreen(),
    );
  }
}

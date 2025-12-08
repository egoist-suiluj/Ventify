// File: lib/main.dart (FINAL FIXED IMPORTS)

import 'package:flutter/material.dart';
import 'package:ventify_app/screens/chat_screen.dart';
import 'package:ventify_app/services/storage_service.dart'; // ✅ FIXED IMPORT

// Gawin nating accessible ang StorageService sa buong app
final StorageService storageService = StorageService();

void main() async {
  // 1. Tiyakin na ready ang Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // 2. I-initialize ang secure storage at Hive (Encryption)
  await storageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ventify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

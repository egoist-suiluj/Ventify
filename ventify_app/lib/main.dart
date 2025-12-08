// File: lib/main.dart (Updated with Hive Setup)

import 'package:flutter/material.dart';
import 'package:ventify_app/screens/chat_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:ventify_app/services/storage_service.dart'; // <--- Bagong Import

// Gawin nating accessible ang StorageService sa buong app
final StorageService storageService = StorageService();

void main() async {
  // 1. Tiyakin na ready ang Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 🚨 BAGONG CODE: I-initialize ang Secure Storage at Hive (Encryption)
  await storageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ventify',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

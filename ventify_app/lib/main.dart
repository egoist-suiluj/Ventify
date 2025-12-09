// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:ventify_app/app.dart'; // Tumatakbo na ang app.dart
import 'package:ventify_app/features/chat/services/storage_service.dart'; // ✅ FIXED PATH

// Gawin nating accessible ang StorageService sa buong app
final StorageService storageService = StorageService();

void main() async {
  // 1. Tiyakin na ready ang Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // 2. I-initialize ang secure storage at Hive
  await storageService.init();

  runApp(VentifyApp()); // Tatawagin ang App Widget sa app.dart
}

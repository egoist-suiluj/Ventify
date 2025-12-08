// File: lib/services/storage_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';

class StorageService {
  static const String _boxName = 'messages';
  static const String _keyName = 'encryption_key';
  final _secureStorage = FlutterSecureStorage();

  // 1. Initializer para sa Hive at Key
  Future<void> init() async {
    await Hive.initFlutter();

    // Get or create encryption key
    final encryptionKey = await _getEncryptionKey();

    // Open encrypted box (Ito ang nagse-secure ng data)
    await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  // 2. Kukunin o gagawa ng bagong encryption key
  Future<Uint8List> _getEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _keyName);

    if (keyString == null) {
      // Gumawa ng bagong 32-byte key
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _keyName,
        value: base64UrlEncode(key),
      );
      // NEW CODE:
      return key is Uint8List
          ? key
          : Uint8List.fromList(key); // <--- I-force convert natin sa Uint8List
    }

    return base64Url.decode(keyString);
  }

  // 3. Simple function para i-save ang message
  Future<void> saveMessage({
    required String sender,
    required String text,
  }) async {
    final box = Hive.box(_boxName);
    await box.add({
      'sender': sender,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // 4. Function para kumuha ng history (UPDATED)
  List<Map<String, dynamic>> getHistory() {
    final box = Hive.box(_boxName);

    // I-convert ang Hive values sa List<Map<String, dynamic>> nang mas safe
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}

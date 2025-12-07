import 'package:flutter/material.dart';
import 'package:ventify_app/screens/chat_screen.dart';
import 'package:flutter/widgets.dart'; // Add this import

void main() async {
  // 👈 Gawing 'async'
  // I-ensure na ready ang Flutter engine bago mag-init ng packages
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Dito natin ilalagay ang Hive at iba pang initialization sa susunod

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

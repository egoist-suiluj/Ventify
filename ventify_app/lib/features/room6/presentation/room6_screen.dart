// File: lib/features/room3/presentation/room3_screen.dart
import 'package:flutter/material.dart';

class Room3Screen extends StatelessWidget {
  const Room3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      ),
      body: Center(
        child: Text("Room 6 Placeholder"),
      ),
    );
  }
}

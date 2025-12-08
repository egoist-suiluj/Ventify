// File: lib/features/voice/presentation/voice_screen.dart
import 'package:flutter/material.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      ),
      body: Center(
        child: Text("Voice Room (WIP)"),
      ),
    );
  }
}

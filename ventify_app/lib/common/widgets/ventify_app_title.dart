// File: lib/common/widgets/ventify_app_title.dart
import 'package:flutter/material.dart';

class VentifyAppTitle extends StatelessWidget {
  const VentifyAppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    // Ang kulay at styling ay kinuha mula sa standard na design natin
    return RichText(
      text: const TextSpan(
        style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'Sans' // Assuming standard font
            ),
        children: [
          // Bold na "Vent"
          TextSpan(text: 'Vent', style: TextStyle(fontWeight: FontWeight.w900)),
          // Light na "ify"
          TextSpan(text: 'ify', style: TextStyle(fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

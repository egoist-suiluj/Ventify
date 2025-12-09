// File: lib/common/widgets/door_card.dart
import 'package:flutter/material.dart';
import 'package:ventify_app/constants/colors.dart'; // 🚨 Import VentifyColors

class DoorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DoorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Ito ang nagiging 'Pader' na Base
        decoration: BoxDecoration(
          color: VentifyColors.cardBg, // White Background
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          // I-clip ang lahat sa loob
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 1. Ang Pinto mismo
              Container(
                decoration: BoxDecoration(
                  color: VentifyColors.door, // Rich Purple Door
                ),
              ),

              // 2. Door Knob (Naka-position sa kanan)
              Positioned(
                top: 50,
                right: 15,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: VentifyColors.doorKnob,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 2),
                  ),
                ),
              ),

              // 3. Text Overlay (Sa ibaba ng pinto)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: VentifyColors.userText, // White text
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                          color: VentifyColors.primaryLight, fontSize: 12),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

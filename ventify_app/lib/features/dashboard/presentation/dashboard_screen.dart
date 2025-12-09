// File: lib/features/dashboard/presentation/dashboard_screen.dart (FINAL STRUCTURE)

import 'package:flutter/material.dart';
import 'package:ventify_app/common/widgets/ventify_app_title.dart';
import 'package:ventify_app/common/widgets/door_card.dart';
import 'package:ventify_app/features/chat/presentation/chat_screen.dart'; // 🚨 FIX: ChatScreen Import
import 'package:ventify_app/constants/colors.dart'; // 🚨 FIX: VentifyColors Import

// Listahan ng Rooms
final List<Map<String, String>> rooms = const [
  {'name': 'Chat Room', 'subtitle': 'Vent & Connect', 'screen': 'chat'},
  {'name': 'Voice Room', 'subtitle': 'Speak & Share', 'screen': 'voice'},
  {'name': 'Room 3', 'subtitle': 'Personal Notes', 'screen': 'room3'},
  {'name': 'Room 4', 'subtitle': 'Dream Journal', 'screen': 'room4'},
  {'name': 'Room 5', 'subtitle': 'Goals & Plans', 'screen': 'room5'},
  {'name': 'Room 6', 'subtitle': 'Gratitude Log', 'screen': 'room6'},
  {'name': 'Room 7', 'subtitle': 'Idea Brainstorm', 'screen': 'room7'},
  {'name': 'Room 8', 'subtitle': 'Daily Reflection', 'screen': 'room8'},
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // File: lib/features/dashboard/presentation/dashboard_screen.dart (UPDATED ANIMATION)

  void _openRoom(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 🚨 FIXED: Sliding Door Effect
          const begin = Offset(1.0, 0.0); // Magmumula sa kanan
          const end = Offset.zero; // Papasok sa gitna
          const curve = Curves.easeOutCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const VentifyAppTitle(),
        backgroundColor: VentifyColors.door, // Door color
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.05,
        ),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];

          return DoorCard(
            title: room['name']!,
            subtitle: room['subtitle']!,
            onTap: () {
              if (index == 0) {
                _openRoom(context, const ChatScreen());
              } else if (index == 1) {
                // VoiceScreen is a placeholder. You need to create lib/features/voice/presentation/voice_screen.dart
                // _openRoom(context, const VoiceScreen());
              }
            },
          );
        },
      ),
    );
  }
}

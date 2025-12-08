// File: lib/features/dashboard/presentation/dashboard_screen.dart (FINAL CODE)
import 'package:ventify_app/features/chat/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
// Para sa Logo
import 'package:ventify_app/common/widgets/ventify_app_title.dart';

// 🚨 UPDATED: Listahan ng Rooms at Descriptions
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

  @override
  Widget build(BuildContext context) {
    // Standard Ventify Blue Color
    const Color ventifyBlue = Color(0xFF0056D2);

    return Scaffold(
      appBar: AppBar(
        // 🚨 TASK 1: Custom Logo Title
        title: const VentifyAppTitle(),
        backgroundColor: ventifyBlue,
        elevation: 0,
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio:
                1.05, // Adjusted aspect ratio for better door look
          ),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final isChat = index == 0;
            const Color ventifyBlue = Color(0xFF0056D2);

            return InkWell(
              // Pinalitan ang Card ng InkWell para mawala ang puting box
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Magne-navigate tayo dito sa next step!
                if (index == 0) {
                  // Chat Room ang index 0
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChatScreen()));
                }
              },
              child: Container(
                // Ito ang box na naglalaman ng Door
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Background color (Putol ang puting box)
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 1. Door Design (Adjusted Height)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0), // Nagbigay ng space sa taas
                        child: Container(
                          width: 80,
                          height: 100, // Bahagyang nilakihan
                          decoration: BoxDecoration(
                            color: isChat
                                ? ventifyBlue.withOpacity(0.9)
                                : Colors.blue.shade800.withOpacity(0.7),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(
                                    5)), // Binawasan ang bottom curve
                          ),
                          child: Center(
                            // Door Handle (Pinakamaliit na yellow dot)
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.amber.shade300,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2. Text Overlay (Binaba ang placement ng text)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room Name Label (Top Right)
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              room['name']!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(), // Ito ang nagtutulak sa text sa baba

                          // Main Title (Name of the Feature)
                          Text(
                            room['name']!,
                            style: TextStyle(
                              fontSize: 18,
                              color: isChat ? ventifyBlue : Colors.black87,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          // Subtitle (Description)
                          Text(
                            room['subtitle']!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

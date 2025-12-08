// File: lib/features/chat/presentation/chat_screen.dart (FINAL & COMPLETE)

import 'package:flutter/material.dart';
import 'package:ventify_app/features/chat/data/message.dart';
import 'package:ventify_app/features/chat/services/chat_service.dart'; // ✅ FIXED IMPORT NAME
import 'package:ventify_app/main.dart';
import 'package:ventify_app/common/widgets/ventify_app_title.dart'; // 🚨 NEW WIDGET IMPORT

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  // 🚨 FIXED: Pinalitan ang ApiService ng ChatService
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];
  bool _isLoading = false;
  bool _isWakingUp = true;

  // --- COLOR PALETTE (Ventify Blue) ---
  final Color _ventifyBlue = const Color(0xFF0056D2);

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _wakeUpServer();
  }

  Future<void> _wakeUpServer() async {
    await _chatService.wakeUp();
    if (mounted) {
      setState(() {
        _isWakingUp = false;
      });
    }
  }

  void _loadHistory() {
    final storedMessages = storageService.getHistory();
    setState(() {
      _messages.addAll(storedMessages.map((data) => Message(
            text: data['text'] as String,
            isUser: data['sender'] == 'user',
            timestamp: DateTime.parse(data['timestamp'] as String),
          )));
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final history = _messages
        .map((m) => {
              "role": m.isUser ? "user" : "model",
              "parts": [
                {"text": m.text}
              ]
            })
        .toList();

    setState(() {
      _messages
          .add(Message(text: text, isUser: true, timestamp: DateTime.now()));
      _isLoading = true;
      _controller.clear();
    });

    await storageService.saveMessage(sender: 'user', text: text);

    try {
      final responseText = await _chatService.sendMessage(
        message: text,
        history: history,
      );

      if (mounted) {
        await storageService.saveMessage(sender: 'model', text: responseText);
        setState(() {
          _messages.add(Message(
              text: responseText, isUser: false, timestamp: DateTime.now()));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(Message(
            text:
                "Pasensya na, paki-check ang internet connection. (Error: $e)",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _ventifyBlue,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20.0,
        // 🚨 TASK 1 & 3 FIX: Custom Logo at Chat Room Label
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Logo at Connecting Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VentifyAppTitle(), // Gagamit ng reusable widget
                if (_isWakingUp)
                  const Text("Connecting...",
                      style: TextStyle(fontSize: 10, color: Colors.white70))
              ],
            ),

            // 2. Chat Room Label (Label sa Kanan)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Chat Room',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      // ... (Rest of the body remains the same)
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: message.isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4, left: 4, right: 4),
                          child: Text(
                            message.isUser ? "You" : "Ventify",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // 🔵 UPDATED: Chat bubble uses Ventify Blue for user
                            color: message.isUser
                                ? _ventifyBlue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: message.isUser
                                  ? const Radius.circular(20)
                                  : const Radius.circular(0),
                              bottomRight: message.isUser
                                  ? const Radius.circular(0)
                                  : const Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: message.isUser
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Ventify is thinking...",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: 12)),
              ),
            ),
          SafeArea(
            top: false,
            bottom: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: _ventifyBlue, // 🔵 UPDATED: Button is Blue
                    radius: 24,
                    child: IconButton(
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _isLoading ? null : _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

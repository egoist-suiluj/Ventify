// File: lib/features/chat/presentation/chat_screen.dart (FINAL STRUCTURE)

import 'package:flutter/material.dart'; // 🚨 FIX: Para sa Alignment, Container, EdgeInsets
import 'package:ventify_app/features/chat/data/message.dart';
import 'package:ventify_app/features/chat/services/chat_service.dart';
import 'package:ventify_app/main.dart';
import 'package:ventify_app/common/widgets/ventify_app_title.dart';
import 'package:ventify_app/constants/colors.dart'; // 🚨 FIX: Para sa VentifyColors

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<Message> _messages = []; // 🚨 FIXED: Private variable
  bool _isLoading = false;
  bool _isWakingUp = true;

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
        backgroundColor: VentifyColors.door, // Ginamit ang Door color
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VentifyAppTitle(),
                if (_isWakingUp)
                  const Text("Connecting...",
                      style: TextStyle(fontSize: 10, color: Colors.white70))
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: VentifyColors.primaryLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Chat Room',
                style: TextStyle(
                    fontSize: 12,
                    color: VentifyColors.userText, // White text
                    fontWeight: FontWeight.w500), // 🚨 FIXED: Comma dito
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Scrollbar(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length, // 🚨 FIXED: Gamit ang _messages
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemBuilder: (context, index) {
                final message = _messages[_messages.length -
                    1 -
                    index]; // 🚨 FIXED: Gamit ang _messages

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    // 🚨 Ito ang nagko-contain ng Label at Bubble
                    crossAxisAlignment: message.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // 1. SENDER LABEL FIX (Kailangang visible sa Light Background)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                        child: Text(
                          message.isUser ? "You" : "Ventify",
                          style: TextStyle(
                            fontSize: 12,
                            color: VentifyColors
                                .textSecondary, // Standard Medium Gray
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // 2. MESSAGE BUBBLE FIX
                      Container(
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? VentifyColors.userBubble
                              : VentifyColors.ventifyBubble,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: message.isUser
                                ? const Radius.circular(16)
                                : const Radius.circular(4),
                            bottomRight: message.isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            // 🚨 Tiyakin na ito ang tama
                            color: message.isUser
                                ? VentifyColors.userText // White text (#FFFFFF)
                                : VentifyColors
                                    .ventifyText, // Dark Gray text (#37474F)
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )),
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
                      maxLines: 5, // Max lines limit
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: VentifyColors.userBubble, // Button color
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

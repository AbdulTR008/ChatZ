import 'package:chatall/screens/chat_list_screen.dart';
import 'package:flutter/material.dart';

// This is kept for backward compatibility
// All references now redirect to ChatListScreen
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatListScreen();
  }
}

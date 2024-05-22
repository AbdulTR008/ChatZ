import 'package:chatz/screens/auth_screen.dart';
import 'package:flutter/material.dart';

import '../controllers/phone_auth_services.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ChatScreen'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: const Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}

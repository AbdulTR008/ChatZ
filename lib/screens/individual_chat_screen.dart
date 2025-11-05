import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';

class IndividualChatScreen extends StatefulWidget {
  final String contactName;

  const IndividualChatScreen({
    super.key,
    required this.contactName,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hey! How are you?',
      'isSentByMe': false,
      'time': '10:25 AM',
    },
    {
      'text': 'I\'m good! Thanks for asking. How about you?',
      'isSentByMe': true,
      'time': '10:26 AM',
    },
    {
      'text': 'I\'m doing great! Want to grab coffee later?',
      'isSentByMe': false,
      'time': '10:27 AM',
    },
    {
      'text': 'Sure! That sounds great. What time works for you?',
      'isSentByMe': true,
      'time': '10:28 AM',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isSentByMe': true,
        'time': TimeOfDay.now().format(context),
      });
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                widget.contactName.isNotEmpty
                    ? widget.contactName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Color(0xFF075E54),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // TODO: Implement voice call
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'view_contact',
                child: Text('View contact'),
              ),
              const PopupMenuItem(
                value: 'media',
                child: Text('Media, links, and docs'),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Text('Search'),
              ),
              const PopupMenuItem(
                value: 'mute',
                child: Text('Mute notifications'),
              ),
              const PopupMenuItem(
                value: 'wallpaper',
                child: Text('Wallpaper'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFECE5DD),
        ),
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    message: message['text'] as String,
                    isSentByMe: message['isSentByMe'] as bool,
                    time: message['time'] as String,
                  );
                },
              ),
            ),
            // Message input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  // Message text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined,
                                color: Colors.grey[600]),
                            onPressed: () {
                              // TODO: Implement emoji picker
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                hintText: 'Message',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                              ),
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_file,
                                color: Colors.grey[600]),
                            onPressed: () {
                              // TODO: Implement file attachment
                            },
                          ),
                          IconButton(
                            icon:
                                Icon(Icons.camera_alt, color: Colors.grey[600]),
                            onPressed: () {
                              // TODO: Implement camera
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF25D366),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

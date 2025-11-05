import 'package:chatall/screens/individual_chat_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';
import '../controllers/phone_auth_services.dart';
import 'auth_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sample chat data - replace with real data from Firebase
    final chats = [
      {
        'name': 'John Doe',
        'lastMessage': 'Hey, how are you?',
        'time': '10:30 AM',
        'unreadCount': 2,
      },
      {
        'name': 'Jane Smith',
        'lastMessage': 'See you tomorrow!',
        'time': 'Yesterday',
        'unreadCount': 0,
      },
      {
        'name': 'Developer Group',
        'lastMessage': 'Check out this new feature...',
        'time': '2 days ago',
        'unreadCount': 5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatAll',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'logout') {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Text('New group'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: const Color(0xFF075E54),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(icon: Icon(Icons.camera_alt)),
                Tab(text: 'CHATS'),
                Tab(text: 'STATUS'),
                Tab(text: 'CALLS'),
              ],
            ),
          ),
          // Chat list
          Expanded(
            child: Container(
              color: Colors.white,
              child: chats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No chats yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        indent: 76,
                        color: Colors.grey[300],
                      ),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return ChatTile(
                          name: chat['name'] as String,
                          lastMessage: chat['lastMessage'] as String,
                          time: chat['time'] as String,
                          unreadCount: chat['unreadCount'] as int,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndividualChatScreen(
                                  contactName: chat['name'] as String,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new chat screen
        },
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}

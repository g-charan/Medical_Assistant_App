import 'package:flutter/material.dart';

// Message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? id;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.id,
  });
}

// Chat conversation model
class ChatConversation {
  final String id;
  final String title;
  final DateTime lastMessage;
  final List<ChatMessage> messages;

  ChatConversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.messages,
  });
}

class ArtificialIntelligenceScreen extends StatefulWidget {
  const ArtificialIntelligenceScreen({super.key});

  @override
  State<ArtificialIntelligenceScreen> createState() =>
      _ArtificialIntelligenceScreenState();
}

class _ArtificialIntelligenceScreenState
    extends State<ArtificialIntelligenceScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ChatMessage> _messages = [];
  List<ChatConversation> _chatHistory = [];
  List<ChatConversation> _filteredChats = [];
  String? _currentChatId;
  bool _isTyping = false;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _startNewChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Simulate loading chat history from backend
  void _loadChatHistory() {
    setState(() {
      _chatHistory = [
        ChatConversation(
          id: "chat_1",
          title: "Health & Exercise Tips",
          lastMessage: DateTime.now().subtract(const Duration(hours: 2)),
          messages: [
            ChatMessage(
              text: "What are the benefits of regular exercise?",
              isUser: true,
              timestamp: DateTime.now().subtract(
                const Duration(hours: 2, minutes: 30),
              ),
            ),
            ChatMessage(
              text:
                  "Regular exercise has numerous benefits including improved cardiovascular health, stronger muscles and bones, better mental health, and enhanced immune function.",
              isUser: false,
              timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            ),
          ],
        ),
        ChatConversation(
          id: "chat_2",
          title: "Cooking Recipes",
          lastMessage: DateTime.now().subtract(const Duration(days: 1)),
          messages: [
            ChatMessage(
              text: "Can you suggest a healthy breakfast recipe?",
              isUser: true,
              timestamp: DateTime.now().subtract(
                const Duration(days: 1, hours: 1),
              ),
            ),
            ChatMessage(
              text:
                  "Here's a great healthy breakfast: Overnight oats with berries, nuts, and honey. It's nutritious and easy to prepare!",
              isUser: false,
              timestamp: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ],
        ),
        ChatConversation(
          id: "chat_3",
          title: "Programming Help",
          lastMessage: DateTime.now().subtract(const Duration(days: 3)),
          messages: [
            ChatMessage(
              text: "How do I optimize my Flutter app performance?",
              isUser: true,
              timestamp: DateTime.now().subtract(
                const Duration(days: 3, hours: 2),
              ),
            ),
            ChatMessage(
              text:
                  "Here are key Flutter optimization tips: Use const constructors, avoid rebuilding widgets unnecessarily, use ListView.builder for long lists, and profile your app regularly.",
              isUser: false,
              timestamp: DateTime.now().subtract(const Duration(days: 3)),
            ),
          ],
        ),
      ];
      _filteredChats = List.from(_chatHistory);
    });
  }

  void _startNewChat() {
    setState(() {
      _currentChatId = "chat_${DateTime.now().millisecondsSinceEpoch}";
      _messages = [];
      _showHistory = false;
    });
  }

  void _loadChat(ChatConversation chat) {
    setState(() {
      _currentChatId = chat.id;
      _messages = List.from(chat.messages);
      _showHistory = false;
    });
    _scrollToBottom();
  }

  void _saveCurrentChat() {
    if (_messages.isNotEmpty && _currentChatId != null) {
      // Generate title from first user message
      String title = _messages.firstWhere((msg) => msg.isUser).text;
      if (title.length > 30) {
        title = "${title.substring(0, 30)}...";
      }

      final newChat = ChatConversation(
        id: _currentChatId!,
        title: title,
        lastMessage: DateTime.now(),
        messages: List.from(_messages),
      );

      setState(() {
        // Remove existing chat with same ID if it exists
        _chatHistory.removeWhere((chat) => chat.id == _currentChatId);
        // Add new chat at the beginning
        _chatHistory.insert(0, newChat);
        _filteredChats = List.from(_chatHistory);
      });
    }
  }

  void _toggleHistory() {
    setState(() {
      _showHistory = !_showHistory;
      if (!_showHistory) {
        _searchController.clear();
        _filteredChats = List.from(_chatHistory);
      }
    });
  }

  void _searchChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(_chatHistory);
      } else {
        _filteredChats = _chatHistory.where((chat) {
          return chat.title.toLowerCase().contains(query.toLowerCase()) ||
              chat.messages.any(
                (msg) => msg.text.toLowerCase().contains(query.toLowerCase()),
              );
        }).toList();
      }
    });
  }

  void _deleteChat(String chatId) {
    setState(() {
      _chatHistory.removeWhere((chat) => chat.id == chatId);
      _filteredChats = List.from(_chatHistory);

      // If deleted chat was current, start new chat
      if (_currentChatId == chatId) {
        _startNewChat();
      }
    });
  }

  void _handleSendPressed() async {
    final String text = _textController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      id: "msg_${DateTime.now().millisecondsSinceEpoch}",
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Generate mock AI response
    final aiResponse = _generateMockResponse(text);
    final aiMessage = ChatMessage(
      text: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
      id: "msg_${DateTime.now().millisecondsSinceEpoch}",
    );

    setState(() {
      _messages.add(aiMessage);
      _isTyping = false;
    });

    _scrollToBottom();

    // Auto-save chat after each exchange
    _saveCurrentChat();
  }

  String _generateMockResponse(String userInput) {
    final responses = [
      "That's an interesting question! Let me help you with that.",
      "I understand what you're asking. Here's what I think...",
      "Based on my knowledge, I can provide you with some insights on this topic.",
      "Great question! This is something many people wonder about.",
      "I'd be happy to help you understand this better.",
    ];

    final detailedResponses = {
      "medicine":
          "Here are some important points about medicine: Always follow your doctor's prescriptions, take medications at the right time, and never share prescription drugs with others.",
      "health":
          "Maintaining good health involves regular exercise, a balanced diet, adequate sleep, stress management, and regular medical check-ups.",
      "ai":
          "Artificial Intelligence is transforming many industries by automating tasks, providing insights from data, and enhancing human capabilities in various fields.",
      "help":
          "I'm here to assist you with any questions you might have. Feel free to ask about health, technology, general knowledge, or anything else!",
    };

    // Check for keywords in user input
    final lowerInput = userInput.toLowerCase();
    for (final keyword in detailedResponses.keys) {
      if (lowerInput.contains(keyword)) {
        return detailedResponses[keyword]!;
      }
    }

    return "${responses[DateTime.now().millisecond % responses.length]} Your question was: \"$userInput\"";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showHistory ? _buildHistoryView() : _buildChatView(),
    );
  }

  Widget _buildChatView() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                // Header with controls
                _buildChatHeader(),
                const SizedBox(height: 16),
                // Chat messages area
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isTyping && index == _messages.length) {
                              return _buildTypingIndicator();
                            }
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                ),
              ],
            ),
            // Input area positioned at bottom
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Row(
      children: [
        // New Chat Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _saveCurrentChat();
              _startNewChat();
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("New Chat"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // History Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _toggleHistory,
            icon: const Icon(Icons.history, size: 18),
            label: const Text("History"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: _toggleHistory,
                icon: const Icon(Icons.arrow_back),
              ),
              const Text(
                "Chat History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search bar
          TextField(
            controller: _searchController,
            onChanged: _searchChats,
            decoration: InputDecoration(
              hintText: "Search conversations...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chat list
          Expanded(
            child: _filteredChats.isEmpty
                ? _buildEmptyHistoryState()
                : ListView.builder(
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) {
                      return _buildChatHistoryItem(_filteredChats[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistoryItem(ChatConversation chat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(Icons.chat, color: Colors.blue, size: 20),
        ),
        title: Text(
          chat.title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat.messages.last.text,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(chat.lastMessage),
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert, size: 20),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _deleteChat(chat.id);
            }
          },
        ),
        onTap: () => _loadChat(chat),
      ),
    );
  }

  Widget _buildEmptyHistoryState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No chat history found",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            "Start a conversation to see it here",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Start a conversation",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ask me anything you'd like to know!",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey, size: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5 + (value * 0.5)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: "Ask anything here",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
                onSubmitted: (_) => _handleSendPressed(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed: _handleSendPressed,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return "${timestamp.day}/${timestamp.month}";
    }
  }
}

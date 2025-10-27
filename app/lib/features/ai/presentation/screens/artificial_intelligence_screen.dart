// Import the general AI model
import 'package:app/features/ai/data/models/ai_model.dart';
import 'package:app/features/ai/data/models/general_ai_model.dart' as general;
import 'package:app/features/ai/presentation/providers/ai_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

// This model is used by the ChatNotifier to manage the live conversation state.
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

// This model is used for the dummy data in the history tab.
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

class ArtificialIntelligenceScreen extends ConsumerStatefulWidget {
  const ArtificialIntelligenceScreen({super.key});

  @override
  ConsumerState<ArtificialIntelligenceScreen> createState() =>
      _ArtificialIntelligenceScreenState();
}

class _ArtificialIntelligenceScreenState
    extends ConsumerState<ArtificialIntelligenceScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // --- STATE MANAGEMENT ---
  // A flag to ensure we only load real history from the provider once.
  bool _isRealHistoryLoaded = false;

  // Local state for the dummy chat history tab.
  List<ChatConversation> _chatHistory = [];
  List<ChatConversation> _filteredChats = [];
  String? _currentChatId;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    // Load the dummy data for the history tab immediately.
    _loadChatHistory();
  }

  // --- FIX 1: Corrected dispose method ---
  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _searchController.dispose();

    // This print log is fine.
    print("--- AI Screen DISPOSING ---");

    // DO NOT call ref.read here. It's redundant because the
    // AppBar's onPressed button already does it, and it causes
    // a "Bad state: Cannot use 'ref' after the widget was disposed" crash.
    // ref.read(medicineChatProvider.notifier).reset(); // <--- REMOVED

    super.dispose();
  }

  // --- DUMMY DATA METHODS ---

  void _loadChatHistory() {
    // This loads the dummy data for the history tab.
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
          title: "Recipe Ideas (Dummy)",
          lastMessage: DateTime.now().subtract(const Duration(days: 1)),
          messages: [
            ChatMessage(
              text: "Got any simple dinner ideas?",
              isUser: true,
              timestamp: DateTime.now().subtract(
                const Duration(days: 1, hours: 1),
              ),
            ),
            ChatMessage(
              text:
                  "How about a quick one-pan lemon herb chicken and veggies? It's healthy, delicious, and easy to clean up!",
              isUser: false,
              timestamp: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ],
        ),
      ];
      _filteredChats = List.from(_chatHistory);
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
      if (_currentChatId == chatId) {
        // If the deleted chat was the active one, start a new chat.
        _startNewChat();
      }
    });
  }

  // --- LIVE CHAT METHODS ---

  void _startNewChat() {
    final medicineId = ref.read(medicineIdProvider);
    final bool isGeneralChat = medicineId.isEmpty;

    if (isGeneralChat) {
      ref.read(generalAiStateProvider.notifier).clearHistory();
    } else {
      ref.read(chatProvider.notifier).clearChat();
    }

    setState(() {
      _currentChatId = "chat_${DateTime.now().millisecondsSinceEpoch}";
      _showHistory = false;
      // Reset the flag to allow real history to be loaded
      _isRealHistoryLoaded = false;
    });
  }

  // This loads messages from a selected dummy conversation into the live chat view.
  void _loadChat(ChatConversation chat) {
    final medicineId = ref.read(medicineIdProvider);
    final bool isGeneralChat = medicineId.isEmpty;

    if (isGeneralChat) {
      // Convert dummy ChatMessage list to general.History list
      final generalHistory = chat.messages.map((msg) {
        return general.History(
          role: msg.isUser ? "user" : "model",
          parts: [general.Part(text: msg.text)],
        );
      }).toList();
      ref
          .read(generalAiStateProvider.notifier)
          .loadConversation(generalHistory);
    } else {
      // Medicine chat uses ChatMessage directly
      ref.read(chatProvider.notifier).loadConversation(chat.messages);
    }

    setState(() {
      _currentChatId = chat.id;
      _showHistory = false;
      // We set this to true because we've manually loaded a chat, overriding the initial provider load.
      _isRealHistoryLoaded = true;
    });
    _scrollToBottom();
  }

  // This saves the current live conversation back to the dummy list.
  void _saveCurrentChat() {
    final medicineId = ref.read(medicineIdProvider);
    final bool isGeneralChat = medicineId.isEmpty;

    List<ChatMessage> messages;

    if (isGeneralChat) {
      // Convert general.History list to dummy ChatMessage list
      final history = ref.read(generalAiHistoryProvider);
      messages = history.map((h) {
        return ChatMessage(
          text: h.parts.first.text,
          isUser: h.role == 'user',
          timestamp: DateTime.now(), // Placeholder timestamp
        );
      }).toList();
    } else {
      // Medicine chat uses ChatMessage directly
      messages = ref.read(chatProvider).messages;
    }

    if (messages.isNotEmpty && _currentChatId != null) {
      String title = messages
          .firstWhere((msg) => msg.isUser, orElse: () => messages.first)
          .text;
      if (title.length > 30) title = "${title.substring(0, 30)}...";

      final newChat = ChatConversation(
        id: _currentChatId!,
        title: title,
        lastMessage: DateTime.now(),
        messages: List.from(messages),
      );

      setState(() {
        _chatHistory.removeWhere((chat) => chat.id == _currentChatId);
        _chatHistory.insert(0, newChat);
        _filteredChats = List.from(_chatHistory);
      });
    }
  }

  void _handleSendPressed() {
    final String text = _textController.text.trim();
    if (text.isEmpty) return;

    final medicineId = ref.read(medicineIdProvider);
    final bool isGeneralChat = medicineId.isEmpty;

    if (isGeneralChat) {
      // Use general AI provider
      ref.read(generalAiStateProvider.notifier).sendMessage(text);
    } else {
      // Use medicine-specific AI provider
      ref.read(chatProvider.notifier).sendMessage(text, medicineId);
    }

    _textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () => _saveCurrentChat());
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

  void _toggleHistory() {
    setState(() {
      _showHistory = !_showHistory;
      if (!_showHistory) _searchController.clear();
    });
  }

  // --- FIX 2: Corrected build method ---
  @override
  Widget build(BuildContext context) {
    // This listener is for scrolling and works for both modes
    ref.listen(chatProvider.select((state) => state.messages.length), (_, __) {
      _scrollToBottom();
    });
    // Add a scroll listener for general chat as well
    ref.listen(generalAiHistoryProvider.select((history) => history.length), (
      _,
      __,
    ) {
      _scrollToBottom();
    });

    final medicineId = ref.watch(medicineIdProvider);
    final bool isGeneralChat = medicineId.isEmpty;

    // --- FIX 2: This listener is now wrapped in a check ---
    // Only listen to the medicine history provider if we are NOT in general chat.
    // This prevents the listener from firing with an empty medicineId
    // when the provider is reset, which caused the 405 error from your log.
    if (!isGeneralChat) {
      ref.listen<AsyncValue<HistoryResponse>>(chatHistoryProvider(medicineId), (
        _,
        next,
      ) {
        // This inner check is redundant now, but harmless.
        if (isGeneralChat) return;

        if (next is AsyncData && !_isRealHistoryLoaded) {
          final historyData = next.value!.history;
          final convertedMessages = historyData
              .map(
                (h) => ChatMessage(
                  text: h.parts.first.text,
                  isUser: h.role == 'user',
                  timestamp: DateTime.now(), // Placeholder timestamp
                ),
              )
              .toList();

          ref.read(chatProvider.notifier).loadConversation(convertedMessages);
          setState(() => _isRealHistoryLoaded = true);
        }
      });
    }

    // Listen to the REAL general history provider
    ref.listen<AsyncValue<general.GeneralAi>>(generalAiProvider, (_, next) {
      // Only run if we are in GENERAL chat mode
      if (!isGeneralChat) return;

      if (next is AsyncData && !_isRealHistoryLoaded) {
        final historyData = next.value!.history;
        // Load this into the GeneralAiNotifier
        ref.read(generalAiStateProvider.notifier).loadConversation(historyData);
        setState(() => _isRealHistoryLoaded = true);
      }
    });

    // Conditionally watch the correct provider for the initial loading screen
    final AsyncValue<dynamic> historyAsync = isGeneralChat
        ? ref.watch(generalAiProvider)
        : ref.watch(chatHistoryProvider(medicineId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // This onPressed logic is correct.
          onPressed: () {
            print(
              "--- AI Screen Back Button TAPPED --- Resetting medicine provider.",
            );
            ref.read(medicineChatProvider.notifier).reset();
            // Then navigate
            context.go('/');
          },
        ),
        title: Text(
          isGeneralChat ? "General Assistant" : "AI Assistant",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      // The body now switches between the live chat and the dummy history list.
      body: _showHistory
          ? _buildHistoryView()
          : historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              // Pass the flag to _buildChatView
              data: (_) => _buildChatView(isGeneralChat),
            ),
    );
  }

  Widget _buildChatView(bool isGeneralChat) {
    final List<ChatMessage> messages;
    final bool isAiTyping;

    if (isGeneralChat) {
      final generalState = ref.watch(generalAiStateProvider);
      isAiTyping = generalState.isLoading;
      // Convert general.History to ChatMessage for rendering
      messages = generalState.history.map((h) {
        return ChatMessage(
          text: h.parts.first.text,
          isUser: h.role == 'user',
          timestamp: DateTime.now(), // Placeholder for UI
        );
      }).toList();
    } else {
      final chatState = ref.watch(chatProvider);
      messages = chatState.messages;
      isAiTyping = chatState.isLoading;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                _buildChatHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: messages.isEmpty && !isAiTyping
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: messages.length + (isAiTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (isAiTyping && index == messages.length) {
                              return _buildTypingIndicator();
                            }
                            // _buildMessageBubble accepts ChatMessage, which is why we converted
                            return _buildMessageBubble(messages[index]);
                          },
                        ),
                ),
              ],
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Row(
      children: [
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
          Row(
            children: [
              IconButton(
                onPressed: _toggleHistory,
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              const Text(
                "Chat History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') _deleteChat(chat.id);
          },
        ),
        onTap: () => _loadChat(chat),
      ),
    );
  }

  // --- ALL OTHER UI HELPER WIDGETS (Unchanged) ---
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
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.blue,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 14),
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
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue,
            child: Icon(Icons.smart_toy, color: Colors.white, size: 14),
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

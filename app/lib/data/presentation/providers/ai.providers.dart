// ai.providers.dart
import 'package:app/common/utils/provider.utils.dart';
import 'package:app/data/models/ai.models.dart';
import 'package:app/data/presentation/screens/artificial_intelligence_screen.dart';
import 'package:app/data/services/ai.services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create a state class to hold both variables
class MedicineChatState {
  final String medicineId;
  final String query;

  const MedicineChatState({required this.medicineId, required this.query});

  // Add copyWith method for easy updates
  MedicineChatState copyWith({String? medicineId, String? query}) {
    return MedicineChatState(
      medicineId: medicineId ?? this.medicineId,
      query: query ?? this.query,
    );
  }

  // Add equality operator for better state comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineChatState &&
          runtimeType == other.runtimeType &&
          medicineId == other.medicineId &&
          query == other.query;

  @override
  int get hashCode => medicineId.hashCode ^ query.hashCode;

  @override
  String toString() =>
      'MedicineChatState(medicineId: $medicineId, query: $query)';
}

// 2. Create the StateNotifier with the state class
class MedicineChatNotifier extends StateNotifier<MedicineChatState> {
  // Initialize with empty state
  MedicineChatNotifier()
    : super(const MedicineChatState(medicineId: "", query: ""));

  // Method to update medicine ID only
  void updateMedicine(String newMedicineId) {
    state = state.copyWith(medicineId: newMedicineId);
  }

  // Method to update query only
  void updateQuery(String newQuery) {
    state = state.copyWith(query: newQuery.trim());
  }

  // Method to update both at once
  void updateBoth(String newMedicineId, String newQuery) {
    state = MedicineChatState(
      medicineId: newMedicineId,
      query: newQuery.trim(),
    );
  }

  // Method to reset everything
  void reset() {
    state = const MedicineChatState(medicineId: "", query: "");
  }
}

// 3. Create the provider - IMPORTANT: Use MedicineChatState as the type parameter
final medicineChatProvider =
    StateNotifierProvider<MedicineChatNotifier, MedicineChatState>((ref) {
      return MedicineChatNotifier();
    });

// 4. Optional: Create separate providers for individual values if you need them
final medicineIdProvider = Provider<String>((ref) {
  return ref.watch(medicineChatProvider).medicineId;
});

final queryProvider = Provider<String>((ref) {
  return ref.watch(medicineChatProvider).query;
});

final remoteAiProvider = createServiceProvider(
  (dio) => RemoteServiceAi(dio: dio),
);

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
class AiUpdateNotifier extends AutoDisposeAsyncNotifier<AiResponse?> {
  @override
  Future<AiResponse?> build() async {
    // Initial state is null, no response yet.
    return null;
  }

  Future<AiResponse> postPrompt(AiChat data) async {
    state = const AsyncLoading();
    try {
      // Assuming your service now returns an AiResponse object
      final AiResponse response = await ref
          .read(remoteAiProvider)
          .postChat(data);
      state = AsyncData(response);
      return response;
    } catch (err, stack) {
      state = AsyncError(err, stack);
      rethrow;
    }
  }
}

final aiUpdateNotifierProvider =
    AsyncNotifierProvider.autoDispose<AiUpdateNotifier, AiResponse?>(() {
      return AiUpdateNotifier();
    });

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading; // To show the 'typing' indicator

  ChatState({this.messages = const [], this.isLoading = false});

  // Helper to easily create a copy of the state
  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// 2. The Notifier that manages the ChatState
class ChatNotifier extends StateNotifier<ChatState> {
  final Ref _ref;
  ChatNotifier(this._ref) : super(ChatState());

  // Handles sending a message and getting a response
  Future<void> sendMessage(String prompt, String medicineId) async {
    // Immediately add the user's message to the list
    final userMessage = ChatMessage(
      text: prompt,
      isUser: true,
      timestamp: DateTime.now(),
      id: "msg_${DateTime.now().millisecondsSinceEpoch}",
    );

    // Update the state to show the user's message and the loading indicator
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // Call your AI service
      final aiResponse = await _ref
          .read(remoteAiProvider)
          .postChat(AiChat(medicineId: medicineId, prompt: prompt));

      final aiMessage = ChatMessage(
        text: aiResponse.response,
        isUser: false,
        timestamp: DateTime.now(),
        id: "msg_${DateTime.now().millisecondsSinceEpoch}_ai",
      );

      // Update state with the AI's response and stop loading
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      // In case of an error, add an error message and stop loading
      final errorMessage = ChatMessage(
        text: "Sorry, an error occurred. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
        id: "msg_${DateTime.now().millisecondsSinceEpoch}_err",
      );
      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
      );
    }
  }

  // Method to load messages from a past conversation
  void loadConversation(List<ChatMessage> messages) {
    state = ChatState(messages: messages, isLoading: false);
  }

  // Method to clear messages for a new chat
  void clearChat() {
    state = ChatState();
  }
}

// 3. The provider that the UI will interact with
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});

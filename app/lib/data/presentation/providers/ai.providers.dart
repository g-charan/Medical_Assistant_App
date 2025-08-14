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

class OcrText {
  final String text;

  OcrText({required this.text});

  @override
  String toString() => text;
}

// OCR state
class OcrState {
  final String rawText; // The original text from the camera
  final OcrResponse? analysisResult; // The structured result from the AI
  final bool isLoading;
  final String? error;

  OcrState({
    this.rawText = "",
    this.analysisResult,
    this.isLoading = false,
    this.error,
  });

  // Helper method to create a copy of the state with new values
  OcrState copyWith({
    String? rawText,
    OcrResponse? analysisResult,
    bool? isLoading,
    String? error,
    bool clearResult = false, // A flag to easily clear old results
  }) {
    return OcrState(
      rawText: rawText ?? this.rawText,
      analysisResult: clearResult
          ? null
          : analysisResult ?? this.analysisResult,
      isLoading: isLoading ?? this.isLoading,
      error: clearResult ? null : error ?? this.error,
    );
  }
}

class OcrNotifier extends StateNotifier<OcrState> {
  final Ref _ref;
  OcrNotifier(this._ref) : super(OcrState());

  // Called when new text is scanned from the camera
  void updateRawText(String newText) {
    state = state.copyWith(rawText: newText, clearResult: true);
  }

  // This is the main method the UI will call to get the analysis.
  // It now returns a structured OcrResponse object.
  Future<OcrResponse?> postTextForAnalysis(String text) async {
    // Set the state to loading and clear any old results
    state = state.copyWith(isLoading: true, rawText: text, clearResult: true);

    try {
      // Call your AI service (assuming it's defined in another provider)
      final OcrResponse response = await _ref
          .read(remoteAiProvider)
          .postOcr(Ocr(text: text));

      // Update the state with the successful result and stop loading
      state = state.copyWith(isLoading: false, analysisResult: response);

      // Return the structured response for immediate use in the UI
      return response;
    } catch (e) {
      final errorMessage = "Failed to analyze text. Please try again.";
      // Update the state with an error message and stop loading
      state = state.copyWith(isLoading: false, error: errorMessage);
      print("Error during OCR analysis: $e");

      // Return null to indicate failure
      return null;
    }
  }

  // Resets the state to its initial values
  void reset() {
    state = OcrState();
  }
}

// --- 3. The Provider Definition ---
// This is what the UI will use to access the OcrNotifier.
final ocrProvider = StateNotifierProvider<OcrNotifier, OcrState>((ref) {
  return OcrNotifier(ref);
});

class OcrResponseState {
  final String? name;
  final String? description;
  final bool isLoading;
  final String? error;

  OcrResponseState({
    this.name,
    this.description,
    this.isLoading = false,
    this.error,
  });

  // Helper method to easily create a copy of the state with new values
  OcrResponseState copyWith({
    String? name,
    String? description,
    bool? isLoading,
    String? error,
  }) {
    return OcrResponseState(
      name: name ?? this.name,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class OcrResponseNotifier extends StateNotifier<OcrResponseState> {
  final Ref _ref;
  OcrResponseNotifier(this._ref) : super(OcrResponseState());

  /// Fetches the analysis from the API and updates the state.
  Future<void> fetchAnalysis(String scannedText) async {
    // Set the state to loading
    state = OcrResponseState(isLoading: true);

    try {
      // Call your remote AI provider
      final OcrResponse response = await _ref
          .read(remoteAiProvider)
          .postOcr(Ocr(text: scannedText));

      // If successful, update the state with the name and description
      state = OcrResponseState(
        name: response.name,
        description: response.description,
        isLoading: false,
      );
    } catch (e) {
      // If an error occurs, update the state with an error message
      state = OcrResponseState(
        isLoading: false,
        error: "Failed to analyze text. Please try again.",
      );
      print("Error during OCR analysis: $e");
    }
  }

  /// Resets the state to its initial values.
  void reset() {
    state = OcrResponseState();
  }
}

final ocrResponseProvider =
    StateNotifierProvider<OcrResponseNotifier, OcrResponseState>((ref) {
      return OcrResponseNotifier(ref);
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

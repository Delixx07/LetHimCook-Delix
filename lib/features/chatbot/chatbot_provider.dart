import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatbotNotifier extends StateNotifier<List<ChatMessage>> {
  ChatbotNotifier() : super([]);

  // Provide at build/run time:
  //   flutter run --dart-define=GROQ_API_KEY=your_key_here
  final String _apiKey =
      const String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  final String _endpoint = 'https://api.groq.com/openai/v1/chat/completions';
  
  bool isLoading = false;

  Future<void> sendMessage(String text, {String? contextInfo}) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(text: text, isUser: true);
    state = [...state, userMsg];
    isLoading = true;

    try {
      final systemMessage = {
        "role": "system",
        "content": "Kamu adalah asisten koki pintar bernama LetHimCook AI. Kamu menjawab dengan singkat, padat, dan ramah. Jawab menggunakan Bahasa Indonesia."
      };
      
      String prompt = text;
      if (contextInfo != null) {
        prompt = "Konteks Resep: $contextInfo\n\nPertanyaan User: $text";
      }

      final messages = [
        systemMessage,
        ...state.map((m) => {
          "role": m.isUser ? "user" : "assistant",
          "content": m.text
        }),
      ];
      
      // Update last message to include context if provided
      if (contextInfo != null && messages.isNotEmpty) {
        messages.last["content"] = prompt;
      }

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": messages,
          "temperature": 0.7,
          "max_tokens": 512,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiText = data['choices'][0]['message']['content'];
        state = [...state, ChatMessage(text: aiText, isUser: false)];
      } else {
        final errorMsg = jsonDecode(response.body)['error']?['message'] ?? response.body;
        state = [...state, ChatMessage(text: "Error (${response.statusCode}): $errorMsg", isUser: false)];
      }
    } catch (e) {
      state = [...state, ChatMessage(text: "Koneksi terputus. Silakan coba lagi. ($e)", isUser: false)];
    } finally {
      isLoading = false;
      // We trigger a state update to notify listeners that isLoading changed,
      // but since isLoading is just a field, we can just re-assign state to trigger rebuilds
      state = [...state];
    }
  }
}

final chatbotProvider = StateNotifierProvider<ChatbotNotifier, List<ChatMessage>>((ref) {
  return ChatbotNotifier();
});

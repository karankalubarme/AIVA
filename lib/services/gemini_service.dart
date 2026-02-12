import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      // Your API Key
      apiKey: 'AIzaSyAd8EWM89tkhMx5xdUMeYDV1va8sm08zhI',
    );

    _chat = _model.startChat();
  }

  Future<String?> sendMessage(String message) async {
    try {
      final content = Content.text(message);
      final response = await _chat.sendMessage(content);
      return response.text;
    } catch (e) {
      // 🔴 THIS PRINTS THE REAL ERROR TO YOUR CONSOLE
      print("---------------------------------------");
      print("❌ GEMINI ERROR: $e");
      print("---------------------------------------");

      // Return the actual error to the chat screen so we can see it
      return "Error: $e";
    }
  }
}
import 'dart:async';
import 'dart:math';
import 'package:chatbot/core/services/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

import '../../features/application/presentation/data/conversation_model.dart';
import '../../features/application/presentation/data/message_model.dart';
import '../../features/application/presentation/service/HiveService.dart';
import '../../features/llm model/api/llm_service.dart';
import '../../features/llm model/api/service_gemini.dart';

class ProviderChat extends GetxController {
  // Current active conversation
  final Rx<Conversation> currentConversation = Conversation(id: "", summary: '').obs;
  final RxList<Conversation> allConversations = <Conversation>[].obs;
  final RxString pendingMessage = "".obs;
  final RxBool waitingForAnswer = false.obs;

  //default llm is gemini
  LlmService llm = GeminiService();


  // Create a new conversation
  void changeLLM(String model, String apiKey) {
    if (model.startsWith("gemini")) {
      llm = GeminiService(otherApiKey: apiKey, model: model);
    }
    if (model.trim().toLowerCase() == "default") {
      llm = GeminiService();
    }
  }

  void startConversation() {
    currentConversation.value = Conversation(id: _generateUniqueId(), summary: '');
  }

  Future<void> sendMessage(String text) async {
    final msg = Message(id: _generateUniqueId(), content: text, isUser: true,);

    /// if this conversation is empty that means its not saved in hive
    await HiveService.saveConversation(currentConversation.value);

    /// Add a message and save to Hive
    currentConversation.value.messages.add(msg);
    //await HiveService.addMessage(currentConversation.value.id, msg);
    shared.loadConversation();

    /// Simulate chatbot response
    waitingForAnswer.value = true;
    final prompt = buildPrompt(
      role: shared.relationship,
      behaviors: shared.behavior,
      summary: currentConversation.value.summary,
      userMessage: text,
    );
    await getAiResponseMessage(prompt);
    waitingForAnswer.value = false;
  }

  Future<void> getAiResponseMessage(String userMessage) async {
    if (!waitingForAnswer.value) return;

    String botContent = "";
    final completer = Completer<String>();

    // Start the LLM call
    llm.generateResponse(
      prompt: userMessage,
      options: {
        'temperature': 0.7,
        'max_tokens': 150,
      },
    ).then((value) {
      if (!completer.isCompleted) completer.complete(value);
    }).catchError((e) {
      if (!completer.isCompleted) completer.completeError(e);
    });

    // Poll for cancellation
    while (!completer.isCompleted) {
      if (!waitingForAnswer.value) {
        debugPrint("Cancelled while waiting for LLM response");
        return; // exit early
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    try {
      botContent = await completer.future;
    } catch (e) {
      debugPrint("Error calling Gemini API: $e");
      botContent = "Sorry, I couldn't generate a response.";
    }

    // Final check before adding the message
    if (!waitingForAnswer.value) return;

    if (botContent.isNotEmpty) {
      final botMessage = Message(
        id: _generateUniqueId(),
        content: botContent,
        isUser: false,
      );

      await HiveService.saveConversation(currentConversation.value);
      currentConversation.value.messages.add(botMessage);

      waitingForAnswer.value = false;
    }
  }


  /// Optimized summary updater
  /*
  Future<void> updateSummary({int maxRecent = 8, int summarizeDelta = 10, int recompressEvery = 4,}) async {
    // If recent messages exceed buffer + delta → summarize delta
    if (convo.recent.length > maxRecent + summarizeDelta) {
      final int cutoff = convo.recent.length - maxRecent;
      final toSummarize = convo.recent.sublist(0, cutoff);

      // Build text block
      final String deltaText = toSummarize
          .map((m) => "${m.role}: ${m.text}")
          .join("\n");

      // Summarize ONLY the delta
      final String newSummary = await summarizer.summarize(deltaText);

      // Merge with existing summary (cheap way: append)
      convo.summary = convo.summary.isEmpty
          ? newSummary
          : "${convo.summary}\n$newSummary";

      convo.merges += 1;

      // Keep only last maxRecent messages
      convo.recent = convo.recent.sublist(cutoff);

      // Occasionally recompress to prevent summary from growing too big
      if (convo.merges % recompressEvery == 0) {
        convo.summary = await summarizer.summarize(convo.summary);
      }
    }
  }

   */

  String buildPrompt({
    required String role,
    required List<String> behaviors,
    String? summary, // compressed history
    required String userMessage,
  }) {
    final buffer = StringBuffer();

    // 1. Role
    if (role.isNotEmpty) {
      buffer.writeln("You are acting as the user's $role.");
    }

    // 2. Behaviors
    if (behaviors.isNotEmpty) {
      buffer.writeln(
          "Adopt the following behaviors: ${behaviors.join(', ')}.");
    }

    // 3. Contextual summary
    if (summary != null && summary.isNotEmpty) {
      buffer.writeln("\nConversation so far (summarized):\n$summary\n");
    }

    // 4. Current user message
    buffer.writeln("User: $userMessage");

    return buffer.toString().trim();
  }


  String _generateUniqueId() {
    final Uuid _uuid = Uuid();
    return _uuid.v4();
  }
}

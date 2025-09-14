import 'dart:async';
import 'dart:math';
import 'package:chatbot/core/services/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

import '../../features/application/domain/models/conversation_model.dart';
import '../../features/application/domain/models/message_model.dart';
import '../../features/application/domain/service/HiveService.dart';
import '../../features/llm model/domain/api/llm_service.dart';
import '../../features/llm model/domain/api/service_gemini.dart';

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
    shared.loadConversation();
    /// get chatbot response
    waitingForAnswer.value = true;
    updateSummary(msg);
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

  Future<void> updateSummary(Message newMsg) async {
    // extract message
    String msgSummary = newMsg.content;
    String actor = (newMsg.isUser)? "user:" : "chatbot:";
    // summarize msg
    if(currentConversation.value.messages.length%5==0){
      String notSummarizedMessages = _getLastMessagesFormatted(
        currentConversation.value.messages,
        5,
        shared.relationship,
      );

      String? result;
      while(result==null){
        print("generating summary");
        result = await llm.generateResponse(prompt: "generate summary for this for contextual memory make it short but contains all the info: ${currentConversation.value.summary}, $notSummarizedMessages");
      }
      currentConversation.value.summary=result;
      print("summary : -----------------------------------------------------------------------------");
      print(currentConversation.value.summary);
    }else{
      //add summarized msg to conversation summary
      currentConversation.value.summary+=",${actor+msgSummary}";
      print("last 5 messages formatted : ******************************************************");
      print(_getLastMessagesFormatted(currentConversation.value.messages,
        5,
        shared.relationship,));
    }
  }
  String _getLastMessagesFormatted(List<Message> messages, int count, String relationship) {
    final lastMessages = messages.length <= count
        ? messages
        : messages.sublist(messages.length - count);
    return lastMessages
        .map((m) => m.isUser
        ? 'user:${m.content}'
        : '${relationship.isNotEmpty ? '$relationship:' : "ai:"}${m.content}')
        .join(',');
  }


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
      buffer.writeln(
          "You have the following context to help you respond naturally if the user message bellow is relevant. Do not mention that it is a summary:\n$summary\n"
      );
    }

    // 4. Current user message
    buffer.writeln("User message: $userMessage");

    return buffer.toString().trim();
  }


  String _generateUniqueId() {
    final Uuid _uuid = Uuid();
    return _uuid.v4();
  }
}

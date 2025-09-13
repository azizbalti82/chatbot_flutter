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
  final Rx<Conversation> currentConversation = Conversation(id: "").obs;
  final RxList<Conversation> allConversations = <Conversation>[].obs;
  final RxString pendingMessage = "".obs;
  final RxBool waitingForAnswer = false.obs;

  //default llm is gemini
  LlmService llm = GeminiService();



  // Create a new conversation
  void changeLLM(String model,String apiKey){
    if(model.startsWith("gemini")){
      llm = GeminiService(otherApiKey: apiKey,model: model);
    }if(model.trim().toLowerCase()=="default"){
      llm = GeminiService();
    }
  }
  void startConversation() {
    currentConversation.value = Conversation(id: _generateUniqueId());
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
    await getAiResponseMessage(text);
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



  String _generateUniqueId() {
    final Uuid _uuid = Uuid();
    return _uuid.v4();
  }
}

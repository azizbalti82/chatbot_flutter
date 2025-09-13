import 'dart:math';
import 'package:chatbot/core/services/shared.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

import '../../features/application/presentation/data/conversation_model.dart';
import '../../features/application/presentation/data/message_model.dart';
import '../../features/application/presentation/service/HiveService.dart';

class ProviderChat extends GetxController {
  // Current active conversation
  final Rx<Conversation> currentConversation = Conversation(id: "").obs;
  final RxList<Conversation> allConversations = <Conversation>[].obs;
  final RxString pendingMessage = "".obs;
  final RxBool waitingForAnswer = false.obs;


  // Create a new conversation
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
    const totalDelay = Duration(seconds: 5);
    const interval = Duration(milliseconds: 100);
    int elapsed = 0;

    while (elapsed < totalDelay.inMilliseconds) {
      if (!waitingForAnswer.value) {
        return;
      }
      await Future.delayed(interval);
      elapsed += interval.inMilliseconds;
    }

    if (!waitingForAnswer.value) return;

    final botMessage = Message(
      id: _generateUniqueId(),
      content: "Bot response to: $userMessage",
      isUser: false,
    );

    /// if this conversation is empty that means its not saved in hive
    await HiveService.saveConversation(currentConversation.value);
    /// Add a message and save to Hive
    currentConversation.value.messages.add(botMessage);
    //await HiveService.addMessage(currentConversation.value.id, botMessage);
    waitingForAnswer.value = false;
  }

  String _generateUniqueId() {
    final Uuid _uuid = Uuid();
    return _uuid.v4();
  }
}

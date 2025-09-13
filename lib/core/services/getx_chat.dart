import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../features/application/presentation/data/conversation_model.dart';
import '../../features/application/presentation/data/message_model.dart';

class ProviderChat extends GetxController {
  // Current active conversation
  final Rx<Conversation> currentConversation = Conversation(id: "").obs;
  final RxString pendingMessage = "".obs;
  final RxBool waitingForAnswer = false.obs;


  /// todo use real id generator so the conversations dont get fucked up
  // Create a new conversation
  void startConversation(String id) {
    currentConversation.value = Conversation(id: id);
  }

  // Send a message from the user
  Future<void> sendMessage(String text) async {
    final msg = Message(
      id: Random().nextInt(100000).toString(),
      content: text,
      isUser: true,
    );
    currentConversation.value.messages.add(msg);

    // Simulate chatbot response
    waitingForAnswer.value = true;
    await simulateBotResponse(text);
    waitingForAnswer.value = false;
  }

  Future<void> simulateBotResponse(String userMessage) async {
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
      id: Random().nextInt(100000).toString(),
      content: "Bot response to: $userMessage",
      isUser: false,
    );

    currentConversation.value.messages.add(botMessage);
    waitingForAnswer.value = false;
  }



  // Clear conversation
  void clearConversation() {
    currentConversation.value.messages.clear();
  }
}

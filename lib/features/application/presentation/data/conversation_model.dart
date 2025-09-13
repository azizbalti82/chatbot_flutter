import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'message_model.dart';

class Conversation {
  final String id;
  final RxList<Message> messages;

  Conversation({
    required this.id,
    List<Message>? messages,
  }) : messages = (messages ?? <Message>[]).obs;

  void addMessage(Message message) {
    messages.add(message); // now reactive
  }
}
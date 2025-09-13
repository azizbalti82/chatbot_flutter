import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../core/services/getx_chat.dart';
import '../../../../../core/services/getx_navigation.dart';
import '../../data/message_model.dart';
import 'package:lottie/lottie.dart';


class ChatBodyView extends StatefulWidget {
  const ChatBodyView({super.key});

  @override
  State<ChatBodyView> createState() => _ChatBodyViewState();
}

class _ChatBodyViewState extends State<ChatBodyView> {
  final ProviderChat chatProvider = Get.find<ProviderChat>();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // scroll whenever messages change
    ever(chatProvider.currentConversation.value.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        var messages = chatProvider.currentConversation.value.messages;
        bool isEmptyConversation = messages.isEmpty;
        return isEmptyConversation
            ? Center(
          child: Text(
            "What can I help you with?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          itemCount: messages.length + (chatProvider.waitingForAnswer.value ? 1 : 0),
          itemBuilder: (context, index) {
            // If this is the last item AND we are waiting for AI, show loading placeholder
            if (chatProvider.waitingForAnswer.value && index == messages.length) {
              return Padding(padding: EdgeInsets.only(bottom: 20),child: Align(
                alignment: Alignment.centerLeft,
                child: Lottie.asset(
                  'assets/animation/${Theme.brightnessOf(context)==Brightness.dark?"loadingMsgForDarkBackground":"loadingMsg"}.json',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ));
            }
            // Otherwise, show the normal message
            final msg = messages[index];
            return Align(
              alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: msg.isUser
                      ? (Theme.brightnessOf(context) == Brightness.light
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFFAA6A25))
                      : (Theme.brightnessOf(context) == Brightness.light
                    ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
                    : const Color(0xFF323232)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  msg.content,
                  style: TextStyle(
                    color: msg.isUser
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          },
        )
        ;
      }),
    );
  }
}

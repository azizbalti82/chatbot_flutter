import 'package:chatbot/core/services/getx_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../../../../core/services/getx_chat.dart';
import 'chat_input_widget.dart';

class ChatInputView extends StatefulWidget {
  const ChatInputView({Key? key}) : super(key: key);

  @override
  State<ChatInputView> createState() => _ChatInputViewState();
}

class _ChatInputViewState extends State<ChatInputView> {
  TextEditingController input = TextEditingController();
  final ProviderChat chatProvider = Get.find<ProviderChat>();
  late ProviderNavigation provider;
  late VoidCallback _listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Get.find<ProviderNavigation>();
    _listener = () {
      final isOpen = provider.drawerMenuController.isOpenNotifier.value;
      print("Drawer state changed: $isOpen");

      if (isOpen) {
        // Remove focus from the TextField and hide the keyboard
        FocusScope.of(context).unfocus();
      }
    };

    provider.drawerMenuController.isOpenNotifier.addListener(_listener);
  }
  @override
  void dispose() {
    input.dispose(); // cleanup controller
    provider.drawerMenuController.isOpenNotifier.removeListener(_listener); // cleanup listener
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MessageInput(
            controller: input,
            placeholder: "Ask anything",
            handleSendMessage: () {
              if (input.text.isNotEmpty) {
                chatProvider.sendMessage(input.text);
              }
              // empty the input
              input.text = "";
              chatProvider.pendingMessage.value = "";
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIconsStroke.informationCircle,
                size: 13,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  "Please double-check responses",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

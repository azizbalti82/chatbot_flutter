import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../../../../core/services/getx_chat.dart';
import 'chat_input_widget.dart';

class ChatInputView extends StatelessWidget {
  TextEditingController input = TextEditingController();
  final ProviderChat chatProvider = Get.find<ProviderChat>();

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
            placeholder:  "Ask anything",
            handleSendMessage: () {
              if(input.text.isNotEmpty){
                chatProvider.sendMessage(input.text);
              }//empty the input
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

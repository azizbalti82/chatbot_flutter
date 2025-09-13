import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../../../../core/services/getx_chat.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final String? placeholder;
  final void Function() handleSendMessage;
  const MessageInput({
    super.key,
    required this.controller,
    this.placeholder,
    required this.handleSendMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool isEmpty = true;
  final ProviderChat chatProvider = Get.find<ProviderChat>();


  @override
  void dispose() {
    widget.controller.removeListener(() {}); // clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
    (){
      isEmpty = chatProvider.pendingMessage.value.isEmpty;
      return TextFormField(
        controller: widget.controller,
        maxLines: 2,
        minLines: 1,
        onChanged: (v) {
          chatProvider.pendingMessage.value = v;
        },
        decoration: InputDecoration(
          suffixIcon: chatProvider.waitingForAnswer.value? Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(onPressed: (){
                  chatProvider.waitingForAnswer.value = false;

                }, icon: Icon(
                        HugeIconsSolid.stop,
                      color: Theme.of(context).colorScheme.surface,
                      size: 20,
                    ),
                  ),
          ) : AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child); // or FadeTransition
            },
            child: !isEmpty
                ? Padding(
              key: ValueKey('sendButton'), // important for AnimatedSwitcher
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.handleSendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: Theme.of(context).colorScheme.surface,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
                : SizedBox(
              key: ValueKey('emptySpace'),
              width: 50,
              height: 50,
            ),
          ),
          hintText: widget.placeholder ?? 'Write something...',
          hintStyle: const TextStyle(fontWeight: FontWeight.w300),
          filled: false,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
    );}));
  }
}

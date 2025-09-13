import 'package:chatbot/core/services/getx_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../../../../core/services/getx_navigation.dart';
class ChatAppBarView extends StatelessWidget {
  final ProviderNavigation provider = Get.find<ProviderNavigation>();
  final ProviderChat chatProvider = Get.find<ProviderChat>();


  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        height: kToolbarHeight,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                provider.toggleDrawer();
              },
              borderRadius:   BorderRadius.circular(20),
              child: Padding(padding: EdgeInsetsGeometry.all(3),child: Icon(HugeIconsStroke.sidebarLeft),)
            ),
            SizedBox(width: 10), //
            Expanded(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface// Set default color
                    ),
                    children: [
                      TextSpan(
                        text: "Hello ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "Ai",
                        style: TextStyle(fontWeight: FontWeight.w300), // Light weight
                      ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(width: 10), // Space between the text and the right icon
            InkWell(
                onTap: (){
                  chatProvider.startConversation();
                },
                borderRadius:   BorderRadius.circular(20),
                child: Padding(padding: EdgeInsetsGeometry.all(3),child: Icon(HugeIconsStroke.bubbleChatAdd),)
            ),
          ],
        ),
      ),
    );
  }
}
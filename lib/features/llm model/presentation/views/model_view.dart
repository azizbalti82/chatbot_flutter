import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/messages_data.dart';
import '../../../../core/widgets/cards_views.dart';
import '../../../../core/widgets/toasts.dart';

class PracticeView extends StatefulWidget {
  const PracticeView({super.key});

  @override
  State<PracticeView> createState() => _State();
}

class _State extends State<PracticeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardWidget(
              title: 'Quiz',
              subtitle: 'Test your knowledge with a quick quiz',
              context: context,
              onTap: () {
                Toast.showMsg(MessagesData.noNewDataAvailable, context);
              },
              iconPath: "quiz",
              iconSize: 3,
            ),
            const SizedBox(height: 15),
            CardWidget(
              title: 'Mistakes',
              subtitle: 'Learn from past errors',
              context: context,
              onTap: () {
                Toast.showMsg(MessagesData.noNewDataAvailable, context);
              },
              iconPath: "close",
              iconSize: 10,
            ),
            const SizedBox(height: 15),
            CardWidget(
              title: 'Learned words',
              subtitle: 'View your growing vocabulary',
              context: context,
              onTap: () {
                Toast.showMsg(MessagesData.noNewDataAvailable, context);
              },
              iconPath: "dictionary",
            ),
            const SizedBox(height: 30),
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child:Text(
                    "Others",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),),
            const SizedBox(height: 15),
            CardWidget(
              title: 'CILS Test',
              subtitle: 'Try a CILS-style exam and test your readiness',
              context: context,
              onTap: () {
                Toast.showError(MessagesData.sectionNotReady, context);
              },
              iconPath: "dictionary",
              locked: true,
            ),
            const SizedBox(height: 15),
            CardWidget(
              title: 'Flash cards',
              context: context,
              subtitle: 'Review terms with flashcards',
              onTap: () {
                Toast.showError(MessagesData.sectionNotReady, context);

              },
              iconPath: "flashcards",
              iconSize: 8,
              locked: true,

            ),

          ],
        )
    );
  }
}

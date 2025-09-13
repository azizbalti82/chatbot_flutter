import 'package:chatbot/features/application/presentation/views/widgets/chat_app_bar_view.dart';
import 'package:chatbot/features/application/presentation/views/widgets/chat_body_view.dart';
import 'package:chatbot/features/application/presentation/views/widgets/chat_input_view.dart';
import 'package:chatbot/features/application/presentation/views/widgets/side_drawer_view.dart';
import 'package:chatbot/features/llm%20model/presentation/views/widgets/fine_tuning_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawer_menu/flutter_drawer_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/services/getx_all.dart';
import '../../../../core/services/getx_chat.dart';
import '../../../../core/services/getx_navigation.dart';
import '../../../../core/services/getx_scroll_manager.dart';
import '../../../../core/services/shared.dart';
import '../../../../core/utils/assets_data.dart';
import 'package:get/get.dart';

import '../../../../core/utils/tools.dart';
import '../../../llm model/presentation/views/widgets/model_chooser_dialogue.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _ChatViewState();
}

class _ChatViewState extends State<AppView> {
  final scrollManager = Get.find<ScrollManager>();
  final chatProvider = Get.find<ProviderChat>();
  final allProvider = Get.find<ProviderAll>();
  final double _rightMargin = 70.0;

  final ProviderNavigation provider = Get.find<ProviderNavigation>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: ChatAppBarView(),
        ),
      ),
      floatingActionButton: Obx(
        () => AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Use ScaleTransition to scale the FAB in/out
            return ScaleTransition(scale: animation, child: child);
          },
          child: (scrollManager.isScrolled.value)
              ? FloatingActionButton(
                  key: ValueKey('fab_visible'),
                  onPressed: scrollManager.scrollToTop,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.arrow_upward_sharp),
                  shape: CircleBorder(),
                )
              : SizedBox.shrink(key: ValueKey('fab_hidden')),
        ),
      ),
      body:  Obx(
      () => DrawerMenu(
        controller: provider.drawerMenuController,
        menu: sideDrawerView(chatProvider,provider,allProvider,context),
        body: Column(
          children: [
            Expanded(child: ChatBodyView()),
            ChatInputView(),
          ],
        ),
        rightMargin: _rightMargin,
        shadowWidth: 10,
        shadowColor: (Theme.brightnessOf(context)==Brightness.dark)? Color(0xFF151515): Color(0xFFF4F4F4),
        scrimBlurEffect: false,
        animationDuration: Duration(milliseconds: 500),
        dragMode: DragMode.always
      )),
    );
  }
}

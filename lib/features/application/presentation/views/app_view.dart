import 'package:chatbot/features/application/presentation/views/widgets/chat_app_bar_view.dart';
import 'package:chatbot/features/application/presentation/views/widgets/chat_body_view.dart';
import 'package:chatbot/features/application/presentation/views/widgets/chat_input_view.dart';
import 'package:chatbot/features/llm%20model/presentation/views/widgets/fine_tuning_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawer_menu/flutter_drawer_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/services/getx_navigation.dart';
import '../../../../core/services/getx_scroll_manager.dart';
import '../../../../core/utils/assets_data.dart';
import 'package:get/get.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _ChatViewState();
}

class _ChatViewState extends State<AppView> {
  final scrollManager = Get.find<ScrollManager>();

  /// If _selectedContent is even, a page without scrolling
  /// and with menu opening by the fling gesture is shown.
  /// Otherwise, a scrollable list is displayed.
  int _selectedContent = 0;
  final double _rightMargin = 70.0;
  final double _menuOverlapWidth = 20;

  final ProviderNavigation provider = Get.find<ProviderNavigation>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: DrawerMenu(
        controller: provider.drawerMenuController,
        menu: _buildMenu(),
        body: Column(
          children: [
            Expanded(child: ChatBodyView()),
            ChatInputView(),
          ],
        ),
        rightMargin: _rightMargin,
        menuOverlapWidth: _menuOverlapWidth,
        shadowWidth: 10,
        shadowColor: const Color(0x11000000),
        animationDuration: Duration(milliseconds: 500),
        dragMode: _selectedContent % 2 != 0
            ? DragMode.always
            : DragMode.onlyFling,
      ),
    );
  }

  Widget _buildMenu() {
    final listView = ListView.builder(
      itemCount: 20, // Add itemCount to prevent infinite items
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            margin: EdgeInsets.only(bottom: 2),
            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Content $index",overflow:TextOverflow.ellipsis,maxLines:1,style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),),
                  Text("3 days ago",overflow:TextOverflow.ellipsis,maxLines:1,style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14,color: Theme.of(context).hintColor),)
                ],
            ),
          ),
          onTap: () {
            provider.drawerMenuController.close();
            setState(() {
              _selectedContent = index;
            });
          },
        );
      },
    );

    Widget menu = SafeArea(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(padding:EdgeInsets.symmetric(horizontal: 20),child:Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  Icon(HugeIconsStroke.clock01,size: 22,),
                  SizedBox(width: 5,),
                  Expanded(child: Text("History",overflow:TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Expanded(child: listView,),
              SizedBox(height: 10,),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: (){
                  // change model

                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(12,5,0,5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: (Theme.brightnessOf(context)==Brightness.dark)?Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).primaryColor.withOpacity(0.1),
                      border: Border.all(color: (Theme.brightnessOf(context)==Brightness.dark)?Theme.of(context).colorScheme.onSurface.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.4),)
                  ),
                  child: Row(
                    children: [
                      Expanded(child:Text("History",overflow:TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),),),
                      IconButton(onPressed: (){
                        Get.bottomSheet(
                          FineTuningLLMSheetView(), // ✅ must be an instance
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        );
                      }, icon: Icon(HugeIconsStroke.settings04,size: 22,),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),

            ],
          )
        ),
      ),
    );

    return menu;
  }
}

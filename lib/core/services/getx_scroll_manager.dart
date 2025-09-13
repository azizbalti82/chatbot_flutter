import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ScrollManager extends GetxController {
  final ScrollController scrollController = ScrollController();

  // Reactive boolean
  final RxBool isScrolled = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      // Update isScrolled reactively
      isScrolled.value = scrollController.offset > 300;
      print(scrollController.offset);
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

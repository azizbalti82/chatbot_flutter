import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawer_menu/flutter_drawer_menu.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProviderNavigation extends GetxController {
  final drawerMenuController = DrawerMenuController();
  toggleDrawer(){
    drawerMenuController.toggle(animated: true);
  }
}

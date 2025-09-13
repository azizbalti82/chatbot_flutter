import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'core/services/getx_all.dart';
import 'core/services/getx_chat.dart';
import 'core/services/getx_navigation.dart';
import 'core/services/getx_scroll_manager.dart';
import 'core/services/shared.dart';
import 'core/utils/constants.dart';
import 'core/utils/theme_data.dart';
import 'features/application/presentation/service/HiveService.dart';
import 'features/application/presentation/views/app_view.dart';
import 'features/application/presentation/views/widgets/system_wrapper_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.packageInfo = await PackageInfo.fromPlatform();
  //init hive:
  await HiveService.initHive();

  Get.put(ScrollManager());
  Get.put(ProviderNavigation());
  Get.put(ProviderChat());
  Get.put(ProviderAll());


  //load settings
  shared.loadFineTuningSettings();
  shared.loadConversation();

  print("conversations : -------------------------------------------------------------------------------------");
  print(shared.conversations);
  //start a conversation
  final providerChat = Get.find<ProviderChat>();
  providerChat.startConversation();



  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.lightTheme,       // use the light theme
      darkTheme: AppTheme.darkTheme,    // use the dark theme
      themeMode: ThemeMode.system,

      home: const SystemUiStyleWrapper(
        child: AppView()
      ),
    );
  }
}
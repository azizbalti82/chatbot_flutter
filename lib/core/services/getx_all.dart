import 'dart:math';
import 'package:chatbot/core/services/shared.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

import '../../features/application/presentation/data/conversation_model.dart';
import '../../features/application/presentation/data/message_model.dart';
import '../../features/application/presentation/service/HiveService.dart';

class ProviderAll extends GetxController {
  // Current active conversation
  final RxString model = "".obs;
}

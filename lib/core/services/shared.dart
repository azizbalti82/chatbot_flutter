import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../features/application/domain/models/conversation_model.dart';
import '../../features/application/domain/service/HiveService.dart';
import '../../features/llm model/domain/service/secret_service.dart';
import '../../features/llm model/domain/service/shared_preferences_service.dart';
import 'getx_all.dart';
import 'getx_chat.dart';

class shared{
  static String relationship = "";
  static List<String> behavior = [];
  static String llmModel = "";
  static String apiKey = "";
  static List<Conversation> conversations = [];

  static Future<void> loadFineTuningSettings()async{
    behavior = await SharedPrefFineTuningService.getBehaviorLLM();
    relationship = await SharedPrefFineTuningService.getRelationshipWithLLM();
    llmModel = await SharedPrefFineTuningService.getLLMModel();
    apiKey = await SecureStorageService().getApiKey() ?? "";

    //setup provider
    final ProviderAll allProvider = Get.find<ProviderAll>();
    allProvider.model.value = llmModel;
  }

  static loadConversation() async{
    final ProviderChat chatProvider = Get.find<ProviderChat>();
    conversations = _getSortedConversations();
    chatProvider.allConversations.value = conversations;
  }

  static List<Conversation> _getSortedConversations() {
    final conversations = HiveService.getAllConversations();

    // Sort by newest message first
    conversations.sort((a, b) {
      final aLatest = a.messages.isNotEmpty
          ? a.messages.last.timestamp
          : DateTime.fromMillisecondsSinceEpoch(0); // If no messages, treat as very old
      final bLatest = b.messages.isNotEmpty
          ? b.messages.last.timestamp
          : DateTime.fromMillisecondsSinceEpoch(0);
      return bLatest.compareTo(aLatest); // Newest first
    });

    return conversations;
  }
}
import 'package:hive/hive.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'package:path_provider/path_provider.dart';


class HiveService {
  static const String conversationBox = "conversations";

  /// Initialize Hive and register adapters
  static Future<void> initHive() async {
    // Get the app documents directory
    final appDocDir = await getApplicationDocumentsDirectory();

    // Initialize Hive with that path
    Hive.init(appDocDir.path);

    // Register your adapters
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(ConversationAdapter());

    // Open the conversation box
    await Hive.openBox<Conversation>(conversationBox);
  }

  /// Add or update a conversation
  static Future<void> saveConversation(Conversation convo) async {
    final box = Hive.box<Conversation>(conversationBox);
    await box.put(convo.id, convo);
  }

  /// Get conversation by ID
  static Conversation? getConversation(String id) {
    final box = Hive.box<Conversation>(conversationBox);
    return box.get(id);
  }

  /// Get all conversations
  static List<Conversation> getAllConversations() {
    final box = Hive.box<Conversation>(conversationBox);
    return box.values.toList();
  }

  /// Delete a conversation
  static Future<void> deleteConversation(String id) async {
    final box = Hive.box<Conversation>(conversationBox);
    await box.delete(id);
  }

  /// Add a message to a conversation
  static Future<void> addMessage(String convoId, Message message) async {
    final box = Hive.box<Conversation>(conversationBox);
    final convo = box.get(convoId);
    if (convo != null) {
      convo.messages.add(message);
      await convo.save();
    }
  }
}

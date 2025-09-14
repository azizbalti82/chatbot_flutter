import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'message_model.dart';

part 'conversation_model.g.dart';
@HiveType(typeId: 1)
class Conversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<Message> messages;

  @HiveField(2)
  String summary; //for contextual memory
  Conversation({
    required this.id,
    required this.summary,
    List<Message>? messages,
  }) : messages = messages ?? [];
}

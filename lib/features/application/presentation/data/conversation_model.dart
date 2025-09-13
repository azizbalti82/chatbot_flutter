import 'package:chatbot/features/application/presentation/service/HiveService.dart';
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

  Conversation({
    required this.id,
    List<Message>? messages,
  }) : messages = messages ?? [];
}

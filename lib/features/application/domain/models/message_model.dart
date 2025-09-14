import 'package:hive/hive.dart';
part 'message_model.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime timestamp;

  Message({
    required this.id,
    required this.isUser,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

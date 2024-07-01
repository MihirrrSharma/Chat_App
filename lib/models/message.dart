import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  DateTime timestamp;

  @HiveField(2)
  String senderId;

  @HiveField(3)
  String receiverId;

  @HiveField(4)
  bool isImage;

  Message({
    required this.text,
    required this.timestamp,
    required this.senderId,
    required this.receiverId,
    this.isImage = false,
  });
}

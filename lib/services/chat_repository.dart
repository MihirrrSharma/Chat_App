import 'package:chat_app/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatRepository {
  Future<List<Message>> getMessages() async {
    final box = await Hive.openBox<Message>('messages');
    return box.values.toList();
  }

  Future<void> sendMessage(Message message) async {
    final box = await Hive.openBox<Message>('messages');
    await box.add(message);
  }
}

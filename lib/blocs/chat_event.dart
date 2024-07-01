part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  // LoadMessagesEvent(String currentUserId, String chatUserId);
}

class SendMessageEvent extends ChatEvent {
  final Message message;

  SendMessageEvent(this.message);
}

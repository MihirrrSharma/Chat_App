part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  MessagesLoaded(this.messages);
}

class ChatError extends ChatState {
  final String errorMessage;

  ChatError(this.errorMessage);
}

import 'package:chat_app/Socket/web_socket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}

class ReceiveMessage extends ChatEvent {
  final String message;
  ReceiveMessage(this.message);
}

// States
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<String> messages;
  ChatLoaded(this.messages);
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WebSocketService webSocketService;

  ChatBloc(this.webSocketService) : super(ChatInitial()) {
    on<SendMessage>((event, emit) {
      webSocketService.sendMessage(event.message);
    });
    webSocketService.messages.listen((message) {
      add(ReceiveMessage(message));
    });
  }
}

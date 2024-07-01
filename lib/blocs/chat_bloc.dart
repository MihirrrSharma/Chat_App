import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/services/chat_repository.dart';
import 'package:chat_app/models/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<LoadMessagesEvent>((event, emit) async {
      emit(MessagesLoading());
      try {
        final messages = await chatRepository.getMessages();
        emit(MessagesLoaded(messages));
      } catch (e) {
        emit(ChatError('Failed to load messages: $e'));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await chatRepository.sendMessage(event.message);
        add(LoadMessagesEvent());
      } catch (e) {
        emit(ChatError('Failed to send message: $e'));
      }
    });
  }
}

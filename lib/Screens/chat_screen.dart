import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/blocs/chat_bloc.dart';
import 'package:chat_app/models/message.dart';
import 'authentication_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String chatUserId;
  final String chatUsername;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.chatUserId,
    required this.chatUsername,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late ChatBloc _chatBloc;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(LoadMessagesEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = Message(
        text: _controller.text,
        timestamp: DateTime.now(),
        senderId: widget.currentUserId,
        receiverId: widget.chatUserId,
        isImage: false,
      );
      _chatBloc.add(SendMessageEvent(message));
      _controller.clear();
    }
  }

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthenticationScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatUsername,
          style: TextStyle(color: Colors.white), // Username text color
        ),
        backgroundColor: Colors.blueAccent, // AppBar background color
        centerTitle: true, // Center align title
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MessagesLoaded) {
                  final messages = state.messages
                      .where((message) =>
                          (message.senderId == widget.currentUserId &&
                              message.receiverId == widget.chatUserId) ||
                          (message.senderId == widget.chatUserId &&
                              message.receiverId == widget.currentUserId))
                      .toList();
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      bool isCurrentUser =
                          message.senderId == widget.currentUserId;
                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 14.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                message.timestamp.toString(),
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                } else {
                  return Center(child: Text('No messages'));
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      _sendMessage();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:chat/models/chat.dart';
import 'package:chat/views/chattile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  String myName;
  ChatMessages({required this.myName});

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    final chats = Provider.of<List<Chat>>(context);
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        if (chats[index].sendBy == widget.myName)
          return ChatTile(chat: chats[index], sendByMe: true);
        else
          return ChatTile(chat: chats[index], sendByMe: false);
      },
    );
  }
}

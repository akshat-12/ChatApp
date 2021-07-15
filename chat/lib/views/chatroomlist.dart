import 'package:chat/models/chatroomModel.dart';
import 'package:chat/views/chatroomtile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomList extends StatefulWidget {
  final String myName;
  ChatRoomList({required this.myName});

  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    final chatrooms = Provider.of<List<ChatRoom>>(context);
    return ListView.builder(
      itemCount: chatrooms.length,
      itemBuilder: (context, index) {
        return ChatRoomTile(
          chatroom: chatrooms[index],
          myName: widget.myName,
        );
      },
    );
  }
}

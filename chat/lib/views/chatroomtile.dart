import 'package:chat/models/chatroomModel.dart';
import 'package:chat/views/conversation1.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatroom;
  final String myName;
  ChatRoomTile({required this.chatroom, required this.myName});

  @override
  Widget build(BuildContext context) {
    if (chatroom.chatRoomId == "") {
      return Container();
    } else {
      return chatroom.chatRoomId.split("_")[0] == myName
          ? ChatCard(
              context, chatroom.chatRoomId.split("_")[1], chatroom, myName)
          : ChatCard(
              context, chatroom.chatRoomId.split("_")[0], chatroom, myName);
    }
  }
}

Widget ChatCard(
    BuildContext context, String name, ChatRoom chatroom, String myName) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    color: Colors.black,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Color(0xFF453e3a),
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(name.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w300)),
              ),
            ),
            SizedBox(
              width: 24,
            ),
            Text(name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300)),
          ],
        ),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Color(0xFF453e3a),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                            chatRoomId: chatroom.chatRoomId, myName: myName)));
              },
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:chat/models/chat.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/chatmessages.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String myName;
  ConversationScreen({required this.chatRoomId, required this.myName});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Database _db = new Database();
  TextEditingController message = new TextEditingController();
  sendMessage() {
    if (message.text != "") {
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "sendBy": widget.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      _db.addConversationMessages(widget.chatRoomId, messageMap);
      message.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Chat>>.value(
      initialData: [Chat(message: "", sendBy: "", time: 0)],
      value: Database().getConversationMessages(widget.chatRoomId),
      child: Scaffold(
        appBar: appBarMain(context),
        backgroundColor: Color(0xFF1F1F1F),
        body: Container(
          child: Stack(
            children: [
              ChatMessages(
                myName: widget.myName,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: message,
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x36FFFFFF),
                                Color(0x0FFFFFFF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Image(
                            image: AssetImage('assets/send.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

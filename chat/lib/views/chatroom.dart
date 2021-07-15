import 'package:chat/models/chatroomModel.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/chatroomlist.dart';
import 'package:chat/views/search.dart';
import 'package:chat/views/signin.dart';
import 'package:chat/widgets/loading.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  Auth _auth = new Auth();
  Database _db = new Database();
  String myName = "";

  void initState() {
    super.initState();
  }

  getName(String? email) async {
    String name = await _db.getUserByUserEmail(email);
    setState(() {
      myName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ModelUser?>(context);
    getName(user!.email);
    return myName == ""
        ? Loading()
        : StreamProvider<List<ChatRoom>>.value(
            initialData: [ChatRoom(chatRoomId: "")],
            value: _db.getChatrooms(myName),
            child: Scaffold(
              backgroundColor: Color(0xFF1F1F1F),
              appBar: AppBar(
                title: Text(
                  'Chat App',
                  style: TextStyle(),
                ),
                backgroundColor: Color(0xFF2E33AE),
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: () {
                      _auth.signOut();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.exit_to_app)),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Search(user: user)));
                },
                child: Icon(Icons.search),
              ),
              body: ChatRoomList(myName: myName),
            ),
          );
  }
}

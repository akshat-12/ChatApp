import 'package:chat/models/user.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/conversation1.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Search extends StatefulWidget {
  final ModelUser? user;
  Search({required this.user});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Database _db = new Database();
  TextEditingController search = new TextEditingController();
  QuerySnapshot? searchSnapshot = null;
  initiateSearch() {
    _db.getUsersByUsername(search.text).then((val) {
      print(val);
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList(ModelUser? user) {
    return searchSnapshot == null
        ? Container(
            color: Color(0xFF1F1F1F),
          )
        : ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapshot!.docs[index].get('name'),
                email: searchSnapshot!.docs[index].get('email'),
                user: user,
              );
            },
          );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic user = widget.user;
    return Scaffold(
      backgroundColor: Color(0xFF1F1F1F),
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: search,
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search username...',
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
                      initiateSearch();
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
                        image: AssetImage('assets/search.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(user),
          ],
        ),
      ),
    );
  }
}

createChatRoomAndStartConversation(
    {required BuildContext context,
    required String username,
    required ModelUser? user}) async {
  String? email = user!.email;
  String myname = await Database().getUserByUserEmail(email);
  if (username == myname) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Illegal reciepent"),
      content: Text("You cannot send messages to yourself."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } else {
    List<String> users = [username, myname];
    String chatRoomId = getChatRoomId(username, myname);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId,
    };
    Database().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  chatRoomId: chatRoomId,
                  myName: myname,
                )));
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  final ModelUser? user;
  SearchTile({required this.username, required this.email, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: simpleTextStyle(),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                email,
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                  context: context, username: username, user: user);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Message',
                style: simpleTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getChatRoomId(String a, String b) {
  print(a);
  print(b);
  if (a.compareTo(b) == 1) {
    return "$a\_$b";
  } else {
    return "$b\_$a";
  }
}

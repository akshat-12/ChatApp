import 'package:chat/helper/authenticate.dart';
import 'package:chat/models/user.dart';
import 'package:chat/views/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ModelUser?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return ChatRooms();
    }
  }
}

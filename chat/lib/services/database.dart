import 'package:chat/models/chat.dart';
import 'package:chat/models/chatroomModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  getUsersByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future<String> getUserByUserEmail(String? email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    return snapshot.docs[0].get('name');
  }

  List<ChatRoom> _ChatRoomListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChatRoom(chatRoomId: doc.get('chatRoomId'));
    }).toList();
  }

  Stream<List<ChatRoom>> getChatrooms(String name) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: name)
        .snapshots()
        .map(_ChatRoomListFromSnapshots);
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  List<Chat> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chat(
          message: doc.get("message"),
          sendBy: doc.get("sendBy"),
          time: doc.get("time"));
    }).toList();
  }

  Stream<List<Chat>> getConversationMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time")
        .snapshots()
        .map(_messageListFromSnapshot);
  }
}

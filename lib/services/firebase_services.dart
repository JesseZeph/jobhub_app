import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';

class FirebaseServices {
  CollectionReference typing = FirebaseFirestore.instance.collection('typing');
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference status = FirebaseFirestore.instance.collection('status');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  createChatRoom(Map<String, dynamic> chatData) {
    chats.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void addTypingStatus(String chatRoomId) {
    typing.doc(chatRoomId).collection('typing').doc(userUid).set({});
  }

  void userStatus() {
    status.doc('status').collection(userUid).doc(userUid).set({});
  }

  void removeStatus(ZoomNotifier zoomNotifier, LoginNotifier loginNotifier) {
    if (zoomNotifier.currentIndex != 1 && loginNotifier.loggedIn == true) {
      status.doc('status').collection(userUid).doc(userUid).delete();
    }
    
  }

  void removeTypingStatus(String chatRoomId) {
    typing.doc(chatRoomId).collection('typing').doc(userUid).delete();
  }

  createChat(String chatRoomId, message) {
    chats.doc(chatRoomId).collection('messages').add(message).catchError((e) {
      debugPrint(e.toString());
    });
    removeTypingStatus(chatRoomId);
    chats.doc(chatRoomId).update({
      'messageType': message['messageType'],
      'sender': message['sender'],
      'profile': message['profile'],
      'id': message['id'],
      'timestamp': Timestamp.now(),
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'read': false
    });
  }

  updateCount(String chatRoomId) {
    chats.doc(chatRoomId).update({'read': true});
  }

  Future<bool> chatRoomExist(String chatRoomId) async {
    DocumentReference chatRoomRef = chats.doc(chatRoomId);

    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    return chatRoomSnapshot.exists;
  }
}

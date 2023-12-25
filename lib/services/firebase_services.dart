import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';

class FirebaseServices {
  CollectionReference typing = FirebaseFirestore.instance.collection('typing');
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference status = FirebaseFirestore.instance.collection('status');
  CollectionReference message =
      FirebaseFirestore.instance.collection('message');

  createChatRoom({chatData}) {
    chats.doc(chatData['charRoomId']).set(chatData).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void addTypingStatus(String chatRoomId) {
    typing.doc(chatRoomId).collection('typing').doc(userUid).set({});
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
      'timestamp': Timestamp.now(),
      'lastChat': message['message'],
      'lastTimeChat': message['time'],
      'read': false,
    });
  }

  updateCount(String chatRoomId) {
    chats.doc(chatRoomId).update({'read': true});
  }

  Future<bool> chatRoomExist(chatRoomId) async {
    DocumentReference chatRoomRef = chats.doc(chatRoomId);
    DocumentSnapshot chatRoomSnapShot = await chatRoomRef.get();

    return chatRoomSnapShot.exists;
  }
}

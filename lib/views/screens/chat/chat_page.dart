import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/agents_provider.dart';
import 'package:jobhubv2_0/services/firebase_services.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseServices services = FirebaseServices();
  TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";
  sendMessage() {
    var chat = Provider.of<AgentNotifier>(context, listen: false).chat;
    Map<String, dynamic> message = {
      'message': messageController.text,
      'messageType': 'text',
      'profile': profile,
      'sender': userUid,
      'time': Timestamp.now()
    };
    services.createChat(chat['chatRoomId'], message);
    messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomId =
        Provider.of<AgentNotifier>(context, listen: false).chat['chatRoomId'];

    final Stream<QuerySnapshot> _typingStatus = FirebaseFirestore.instance
        .collection('typing')
        .doc(chatRoomId)
        .collection('typing')
        .snapshots();

    return Scaffold();
  }
}

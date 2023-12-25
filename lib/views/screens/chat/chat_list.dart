import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/agents_provider.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/models/request/agents/agents.dart';
import 'package:jobhubv2_0/services/firebase_services.dart';
import 'package:jobhubv2_0/utils/date.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/loader.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';
import 'package:jobhubv2_0/views/screens/agent/agent_details.dart';
import 'package:jobhubv2_0/views/screens/auth/non_user.dart';
import 'package:jobhubv2_0/views/screens/auth/profile_page.dart';
import 'package:jobhubv2_0/views/screens/chat/chat_page.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 3, vsync: this);

  String imageUrl =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b8bac89b-b85d-4ead-bb9e-57c96e03a08b-vinci_02.jpg";

  FirebaseServices services = FirebaseServices();

  final Stream<QuerySnapshot> _chat = FirebaseFirestore.instance
      .collection('chats')
      .where('user', arrayContains: userUid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(12.w),
          child: DrawerWidget(color: Color(kLight.value)),
        ),
        title: loginNotifier.loggedIn == false
            ? const SizedBox.shrink()
            : TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                    color: const Color(0x00BABABA),
                    borderRadius: BorderRadius.all(Radius.circular(25.w))),
                labelColor: Color(kLight.value),
                dividerHeight: 0,
                unselectedLabelColor: Colors.grey.withOpacity(.5),
                padding: EdgeInsets.all(3.w),
                labelStyle: appStyle(12, Color(kLight.value), FontWeight.w500),
                tabs: const [
                    Tab(
                      text: "MESSAGE",
                    ),
                    Tab(
                      text: "ONLINE",
                    ),
                    Tab(
                      text: "GROUPS",
                    )
                  ]),
      ),
      body: loginNotifier.loggedIn == false
          ? const NonUser()
          : TabBarView(controller: tabController, children: [
              Stack(
                children: [
                  Positioned(
                      top: 20,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 25.w, right: 0.w),
                        height: 220.h,
                        decoration: BoxDecoration(
                          color: Color(kNewBlue.value),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.w),
                            topRight: Radius.circular(20.w),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                    text: "Agents and Companies",
                                    style: appStyle(12, Color(kLight.value),
                                        FontWeight.normal)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      AntDesign.ellipsis1,
                                      color: Color(kLight.value),
                                    ))
                              ],
                            ),
                            Consumer<AgentNotifier>(
                              builder: (context, agentNotifier, child) {
                                var agents = agentNotifier.getAgents();
                                return FutureBuilder<List<Agents>>(
                                    future: agents,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 90.h,
                                          child: ListView.builder(
                                              itemCount: 7,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {},
                                                  child: buildAgentAvatar(
                                                    "Agent $index",
                                                    imageUrl,
                                                  ),
                                                );
                                              }),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return SizedBox(
                                          height: 90.h,
                                          child: ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                var agent =
                                                    snapshot.data![index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    agentNotifier.agent = agent;
                                                    Get.to(() =>
                                                        const AgentDetails());
                                                  },
                                                  child: buildAgentAvatar(
                                                    agent.username,
                                                    agent.profile,
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                    });
                              },
                            )
                          ],
                        ),
                      )),
                  Positioned(
                    top: 150.h,
                    right: 0,
                    left: 0,
                    child: Container(
                        width: width,
                        height: hieght,
                        decoration: BoxDecoration(
                          color: Color(kGreen.value),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.w),
                            topRight: Radius.circular(20.w),
                          ),
                        ),
                        child: StreamBuilder(
                            stream: _chat,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error ${snapshot.error}');
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const PageLoader();
                              } else if (snapshot.data!.docs.isEmpty) {
                                return const NoSearchResults(
                                    text: 'No chats available');
                              } else {
                                final chatList = snapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: chatList.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(left: 25),
                                  itemBuilder: ((context, index) {
                                    final chat = chatList[index].data
                                        as Map<String, dynamic>;
                                    Timestamp lastChatTime =
                                        chat['lastChatTime'];
                                    DateTime lastChatTimeDate =
                                        lastChatTime.toDate();
                                    return Consumer<AgentNotifier>(
                                      builder: (context, agentNotifier, child) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (chat['sender'] != userUid) {
                                              services.updateCount(
                                                  chat['charRoomId']);
                                            } else {}
                                            agentNotifier.chat = chat;
                                            Get.to(() => const ChatPage());
                                          },
                                          child: buildChatRow(
                                            chat['name']
                                                ? chat['agentName']
                                                : chat['name'],
                                            chat['message'],
                                            chat['profile'],
                                            chat['read'] == false ? 0 : 1,
                                            lastChatTimeDate,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                );
                              }
                            })),
                  )
                ],
              ),
              Container(
                height: hieght,
                width: width,
                color: Colors.green,
              ),
              Container(
                height: hieght,
                width: width,
                color: Colors.blueAccent,
              ),
            ]),
    );
  }
}

Padding buildAgentAvatar(String name, String filename) {
  return Padding(
    padding: EdgeInsets.only(right: 20.w),
    child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(99.w)),
                border: Border.all(width: 2, color: Color(kLight.value))),
            child: CircularAvata(image: filename, w: 50, h: 50)),
        const HeightSpacer(size: 5),
        ReusableText(
            text: name,
            style: appStyle(11, Color(kLight.value), FontWeight.normal))
      ],
    ),
  );
}

Column buildChatRow(
    String name, String message, String filename, int msgCount, time) {
  return Column(
    children: [
      FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircularAvata(image: filename, w: 50, h: 50),
                const WidthSpacer(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: name,
                        style: appStyle(12, Colors.grey, FontWeight.w400)),
                    const HeightSpacer(size: 5),
                    SizedBox(
                      width: width * 0.65,
                      child: ReusableText(
                        text: message,
                        style: appStyle(12, Colors.grey, FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w, left: 15.w, top: 5.w),
              child: Column(
                children: [
                  ReusableText(
                      text: duTimeLineFormat(time),
                      style: appStyle(10, Colors.black, FontWeight.normal)),
                  const HeightSpacer(size: 15),
                  if (msgCount > 0)
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(kLightBlue.value),
                      child: ReusableText(
                          text: msgCount.toString(),
                          style: appStyle(
                              8, Color(kLight.value), FontWeight.normal)),
                    )
                ],
              ),
            )
          ],
        ),
      )
    ],
  );
}

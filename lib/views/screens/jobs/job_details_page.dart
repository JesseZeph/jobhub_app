import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/bookmark_provider.dart';
import 'package:jobhubv2_0/controllers/jobs_provider.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/applied/applied.dart';
import 'package:jobhubv2_0/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhubv2_0/models/response/bookmarks/book_res.dart';
import 'package:jobhubv2_0/models/response/jobs/get_job.dart';
import 'package:jobhubv2_0/services/firebase_services.dart';
import 'package:jobhubv2_0/services/helpers/applied_helper.dart';
import 'package:jobhubv2_0/services/helpers/jobs_helper.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/screens/jobs/update_job.dart';
import 'package:jobhubv2_0/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobDetails extends StatefulWidget {
  const JobDetails(
      {super.key,
      required this.title,
      required this.id,
      required this.agentName});

  final String title;
  final String id;
  final String agentName;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  FirebaseServices services = FirebaseServices();
  late Future<GetJobRes> job;
  bool isAgent = false;
  @override
  void initState() {
    getJob();
    getPrefs();
    super.initState();
  }

  getJob() {
    job = JobsHelper.getJob(widget.id);
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAgent = prefs.getBool('isAgent') ?? false;
  }

  createChat(Map<String, dynamic> jobDetails, List<String> users,
      String chatRoomId, String messageType) {
    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'read': false,
      'profile': profile,
      'sender': userUid,
      'name': username,
      'agentName': widget.agentName,
      'messageType': messageType,
      'lastChat': "Good day, Sir! I'm interested in this job.",
      'lastChatTime': Timestamp.now()
    };
    services.createChatRoom(chatData: chatData);
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);

    return Consumer<JobsNotifier>(builder: (context, jobsNotifier, child) {
      jobsNotifier.getJob(widget.id);
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(actions: [
              loginNotifier.loggedIn != false
                  ? Consumer<BookNotifier>(
                      builder: (context, bookNotifier, child) {
                        bookNotifier.getBookMark(widget.id);
                        return GestureDetector(
                          onTap: () {
                            if (bookNotifier.bookmark == true) {
                              bookNotifier
                                  .deleteBookMark(bookNotifier.bookmarkId);
                            } else {
                              BookMarkReqRes model =
                                  BookMarkReqRes(job: widget.id);
                              var newModel = bookMarkReqResToJson(model);
                              bookNotifier.addBookMark(newModel);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Icon(bookNotifier.bookmark == false
                                ? Fontisto.bookmark
                                : Fontisto.bookmark_alt),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink()
            ], child: const BackBtn())),
        body: buildStyleContainer(
          context,
          FutureBuilder<GetJobRes>(
              future: job,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PageLoader();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  final job = snapshot.data;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              width: width,
                              height: hieght * 0.27,
                              decoration: BoxDecoration(
                                  color: Color(kLightGrey.value),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/jobs.png'),
                                      opacity: 0.35),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9.w))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30.w,
                                    backgroundImage:
                                        NetworkImage(job!.imageUrl),
                                  ),
                                  const HeightSpacer(size: 10),
                                  ReusableText(
                                      text: job.title,
                                      style: appStyle(16, Color(kDark.value),
                                          FontWeight.w600)),
                                  const HeightSpacer(size: 5),
                                  ReusableText(
                                      text: job.location,
                                      style: appStyle(
                                          16,
                                          Color(kDarkGrey.value),
                                          FontWeight.w600)),
                                  const HeightSpacer(size: 15),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomOutlineBtn(
                                            width: width * .26,
                                            hieght: hieght * .04,
                                            text: job.contract,
                                            color: Color(kOrange.value)),
                                        Row(
                                          children: [
                                            ReusableText(
                                                text: job.salary,
                                                style: appStyle(
                                                    16,
                                                    Color(kDark.value),
                                                    FontWeight.w600)),
                                            ReusableText(
                                                text: "/${job.period}",
                                                style: appStyle(
                                                    16,
                                                    Color(kDarkGrey.value),
                                                    FontWeight.w600)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const HeightSpacer(size: 20),
                            ReusableText(
                                text: 'Description',
                                style: appStyle(
                                    16, Color(kDark.value), FontWeight.w600)),
                            const HeightSpacer(size: 10),
                            Text(
                              job.description,
                              textAlign: TextAlign.justify,
                              maxLines: 9,
                              style: appStyle(12, Color(kDarkGrey.value),
                                  FontWeight.normal),
                            ),
                            const HeightSpacer(size: 20),
                            ReusableText(
                                text: 'Requirements',
                                style: appStyle(
                                    16, Color(kDark.value), FontWeight.w600)),
                            const HeightSpacer(size: 10),
                            SizedBox(
                              height: hieght * 0.6,
                              child: ListView.builder(
                                  itemCount: job.requirements.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var requirement = job.requirements[index];
                                    String bullet = '\u2022';
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.w),
                                      child: Text(
                                        "$bullet $requirement",
                                        style: appStyle(
                                            12,
                                            Color(kDarkGrey.value),
                                            FontWeight.normal),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 20.0.w),
                              child: !isAgent
                                  ? CustomOutlineBtn(
                                      text: !loginNotifier.loggedIn
                                          ? "Please Login"
                                          : "Apply",
                                      hieght: hieght * 0.06,
                                      onTap: () async {
                                        Map<String, dynamic> jobDetails = {
                                          'job_id': job.id,
                                          'image_url': job.imageUrl,
                                          'salary':
                                              '${job.salary} per ${job.period}',
                                          'title': job.title,
                                          'company': job.company,
                                        };
                                        List<String> users = [
                                          job.agentId,
                                          userUid,
                                        ];
                                        String chatRoomId =
                                            '${job.id}.$userUid';
                                        String messageType = 'text';

                                        bool doesChatExist = await services
                                            .chatRoomExist(chatRoomId);

                                        if (doesChatExist == false) {
                                          createChat(jobDetails, users,
                                              chatRoomId, messageType);

                                          AppliedPost model =
                                              AppliedPost(job: job.id);
                                          var newModel =
                                              appliedPostToJson(model);
                                          AppliedHelper.applyJobs(newModel);

                                          zoomNotifier.currentIndex = 1;
                                          Get.to(() => const Mainscreen());
                                        } else {
                                          zoomNotifier.currentIndex = 1;
                                          Get.to(() => const Mainscreen());
                                        }
                                      },
                                      color: Color(kLight.value),
                                      color2: Color(kOrange.value),
                                    )
                                  : CustomOutlineBtn(
                                      text: 'Edit Job',
                                      onTap: () {
                                        jobUpdate = job;
                                        Get.off(() => const UpdateJobs());
                                      },
                                      hieght: hieght * 0.06,
                                      color: Color(kLight.value),
                                      color2: Color(kOrange.value),
                                    )),
                        )
                      ],
                    ),
                  );
                }
              }),
        ),
      );
    });
  }
}

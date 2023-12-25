import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/response/auth/profile_model.dart';
import 'package:jobhubv2_0/services/helpers/auth_helper.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';
import 'package:jobhubv2_0/views/screens/auth/non_user.dart';
import 'package:jobhubv2_0/views/screens/auth/widgets/edit_button.dart';
import 'package:jobhubv2_0/views/screens/auth/widgets/skills.dart';
import 'package:jobhubv2_0/views/screens/jobs/add_jobs.dart';
import 'package:jobhubv2_0/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.drawer});

  final bool drawer;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileRes> userProfile;
  String username = '';
  String profilePic = '';
  ProfileRes? profile;
  bool isLogged = false;
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

  @override
  void initState() {
    super.initState();
    getName();
    getProfile();
  }

  getProfile() {
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    if (widget.drawer == false && loginNotifier.loggedIn == true) {
      userProfile = AuthHelper.getProfile();
    } else if (widget.drawer == true && loginNotifier.loggedIn == true) {
      userProfile = AuthHelper.getProfile();
    } else {}
  }

  getName() async {
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.drawer == false && loginNotifier.loggedIn == true) {
      username = prefs.getString('username') ?? '';
      profilePic = prefs.getString('profile') ?? '';
    } else if (widget.drawer == true && loginNotifier.loggedIn == true) {
      username = prefs.getString('username') ?? '';
      profilePic = prefs.getString('profile') ?? '';
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
        backgroundColor: Color(kNewBlue.value),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            color: Color(kNewBlue.value),
            text: loginNotifier.loggedIn ? username.toUpperCase() : '',
            child: Padding(
              padding: EdgeInsets.all(12.0.h),
              child: widget.drawer == false
                  ? const BackBtn()
                  : DrawerWidget(color: Color(kLight.value)),
            ),
          ),
        ),
        body: loginNotifier.loggedIn == false
            ? const NonUser()
            : Stack(
                children: [
                  Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 20),
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Color(kLightBlue.value)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularAvata(
                                    image:
                                        profilePic == '' ? image : profilePic,
                                    w: 50,
                                    h: 50),
                                const WidthSpacer(width: 20),
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(3.w),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: Colors.white30),
                                        child: ReusableText(
                                            text: profile == null
                                                ? "user email"
                                                : profile!.email,
                                            style: appStyle(
                                                14,
                                                Color(kLight.value),
                                                FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0.w),
                                  child: Icon(
                                    Feather.edit,
                                    color: Color(kLight.value),
                                  ),
                                ))
                          ],
                        ),
                      )),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    top: 90.h,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Color(kLight.value)),
                      child: FutureBuilder(
                          future: userProfile,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const PageLoader();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              profile = snapshot.data;
                              return buildStyleContainer(
                                  context,
                                  ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    children: [
                                      const HeightSpacer(size: 30),
                                      ReusableText(
                                          text: 'Profile',
                                          style: appStyle(
                                              15,
                                              Color(kDark.value),
                                              FontWeight.w600)),
                                      const HeightSpacer(size: 10),
                                      Stack(
                                        children: [
                                          Container(
                                            width: width,
                                            height: hieght * 0.12,
                                            decoration: BoxDecoration(
                                                color: Color(kLightGrey.value),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 12.w),
                                                  width: 60.w,
                                                  height: 70.h,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Color(kLight.value),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  12))),
                                                  child: const Icon(
                                                      FontAwesome5Regular
                                                          .file_pdf,
                                                      color: Colors.red,
                                                      size: 40),
                                                ),
                                                const WidthSpacer(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ReusableText(
                                                        text:
                                                            "Upload Your Resume",
                                                        style: appStyle(
                                                            16,
                                                            Color(kDark.value),
                                                            FontWeight.w500)),
                                                    FittedBox(
                                                      child: Text(
                                                          "Please make sure to upload your resume in PDF format",
                                                          style: appStyle(
                                                              8,
                                                              Color(kDarkGrey
                                                                  .value),
                                                              FontWeight.w500)),
                                                    ),
                                                  ],
                                                ),
                                                const WidthSpacer(width: 1)
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              right: 0.w,
                                              child: EditButton(
                                                onTap: () {},
                                              ))
                                        ],
                                      ),
                                      const HeightSpacer(size: 20),
                                      const SkillsWidget(),
                                      const HeightSpacer(size: 20),
                                      profile!.isAgent
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ReusableText(
                                                    text: 'Agent Section',
                                                    style: appStyle(
                                                        14,
                                                        Color(kDark.value),
                                                        FontWeight.w600)),
                                                const HeightSpacer(size: 20),
                                                CustomOutlineBtn(
                                                    width: width,
                                                    onTap: () {
                                                      Get.to(() =>
                                                          const AddJobs());
                                                    },
                                                    hieght: 40.h,
                                                    text: "Add Jobs",
                                                    color:
                                                        Color(kNewBlue.value)),
                                                const HeightSpacer(size: 10),
                                                CustomOutlineBtn(
                                                    width: width,
                                                    onTap: () {},
                                                    hieght: 40.h,
                                                    text: "Update Information",
                                                    color:
                                                        Color(kNewBlue.value)),
                                              ],
                                            )
                                          : CustomOutlineBtn(
                                              width: width,
                                              onTap: () {},
                                              hieght: 40.h,
                                              text: "Apply to become an agent",
                                              color: Color(kNewBlue.value)),
                                      const HeightSpacer(size: 20),
                                      CustomOutlineBtn(
                                          width: width,
                                          onTap: () {
                                            zoomNotifier.currentIndex = 0;
                                            loginNotifier.logout();
                                            Get.offAll(
                                                () => const Mainscreen());
                                          },
                                          hieght: 40.h,
                                          text: "Proceed to logout",
                                          color: Color(kNewBlue.value))
                                    ],
                                  ));
                            }
                          }),
                    ),
                  ),
                ],
              ));
  }
}

class CircularAvata extends StatelessWidget {
  const CircularAvata(
      {super.key, required this.image, required this.w, required this.h});
  final String image;
  final double w;
  final double h;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(99.w)),
      child: CachedNetworkImage(
        imageUrl: image,
        width: w,
        height: h,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

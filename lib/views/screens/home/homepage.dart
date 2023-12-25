import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/heading_widget.dart';
import 'package:jobhubv2_0/views/common/search.dart';
import 'package:jobhubv2_0/views/screens/auth/login.dart';
import 'package:jobhubv2_0/views/screens/auth/profile_page.dart';
import 'package:jobhubv2_0/views/screens/jobs/job_list_page.dart';
import 'package:jobhubv2_0/views/screens/jobs/widgets/PopularJobs.dart';
import 'package:jobhubv2_0/views/screens/jobs/widgets/Recentlist.dart';
import 'package:jobhubv2_0/views/screens/search/search_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    loginNotifier.getPref();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.all(12.0.h),
                  child: GestureDetector(
                    onTap: () {
                      loginNotifier.loggedIn == true ?
                      Get.to(() => const ProfilePage(drawer: false))
                      : Get.to(() => const LoginPage());
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        height: 25.w,
                        width: 25.w,
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
              child: Padding(
                padding: EdgeInsets.all(12.0.h),
                child: DrawerWidget(color: Color(kDark.value)),
              ))),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search \n Find & Apply",
                style: appStyle(38, Color(kDark.value), FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              SearchWidget(
                onTap: () {
                  Get.to(() => const SearchPage());
                },
              ),
              SizedBox(height: 30.h),
              HeadingWidget(
                text: 'Popular Jobs',
                onTap: () {
                  Get.to(() => const JobListPage());
                },
              ),
              SizedBox(height: 15.h),
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.w)),
                  child: const PopularJobs()),
              SizedBox(height: 15.h),
              HeadingWidget(
                text: 'Recently Posted ',
                onTap: () {
                  Get.to(() => const JobListPage());
                },
              ),
              SizedBox(height: 15.h),
              const RecentJobs()
            ],
          ),
        ),
      )),
    );
  }
}

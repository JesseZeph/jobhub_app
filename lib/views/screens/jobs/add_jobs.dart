import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/skills_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/jobs/create_job.dart';
import 'package:jobhubv2_0/services/helpers/jobs_helper.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/common/textfield.dart';
import 'package:jobhubv2_0/views/screens/auth/profile_page.dart';
import 'package:jobhubv2_0/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobs extends StatefulWidget {
  const AddJobs({super.key});

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  TextEditingController title = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController contract = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController period = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
  TextEditingController rq1 = TextEditingController();
  TextEditingController rq2 = TextEditingController();
  TextEditingController rq3 = TextEditingController();
  TextEditingController rq4 = TextEditingController();
  TextEditingController rq5 = TextEditingController();
  TextEditingController imageController = TextEditingController(
      text:
          "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg");
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

  @override
  Widget build(BuildContext context) {
    var skillsNotifier = Provider.of<SkillsNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.w),
          child: CustomAppBar(
              actions: [
                Consumer<SkillsNotifier>(
                  builder: (context, skillsNotifier, child) {
                    return skillsNotifier.logoUrl.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularAvata(
                                image: skillsNotifier.logoUrl, w: 30, h: 40),
                          )
                        : const SizedBox.shrink();
                  },
                )
              ],
              color: Color(kNewBlue.value),
              text: "Upload Jobs",
              child: const BackBtn())),
      body: Stack(
        children: [
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(kLight.value)),
                child: buildStyleContainer(
                    context,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
                      child: ListView(
                        children: [
                          const HeightSpacer(size: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Job Title"),
                                hintText: "Job Title",
                                controller: title),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Company"),
                                hintText: "Company",
                                controller: company),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Location"),
                                hintText: "Location",
                                controller: location),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Contract"),
                                hintText: "Contract",
                                controller: contract),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Salary"),
                                hintText: "Salary",
                                controller: salary),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Salary period"),
                                hintText: "Monthly | Annual | Weekly",
                                controller: period),
                          ),
                          Consumer<SkillsNotifier>(
                            builder: (context, skillsNotifier, child) {
                              return SizedBox(
                                width: width,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.8,
                                      height: 60,
                                      child: buildtextfield(
                                          onChanged: (value) {
                                            skillsNotifier.setLogoUrl(
                                                imageController.text);
                                          },
                                          onSubmitted: (value) {
                                            if (value!.isEmpty &&
                                                value.contains('https://')) {
                                              return ("Please fill the field");
                                            } else {
                                              return null;
                                            }
                                          },
                                          label: const Text("Image Url"),
                                          hintText: "Image Url",
                                          controller: imageController),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        skillsNotifier
                                            .setLogoUrl(imageController.text);
                                      },
                                      child: Icon(Entypo.upload_to_cloud,
                                          size: 35,
                                          color: Color(kNewBlue.value)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                height: 100,
                                maxLines: 3,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Description"),
                                hintText: "Description",
                                controller: description),
                          ),
                          ReusableText(
                              text: "Requirements",
                              style:
                                  appStyle(15, Colors.black, FontWeight.w600)),
                          const HeightSpacer(size: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq1),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq2),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq4),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq5),
                          ),
                          CustomOutlineBtn(
                              width: width,
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String agentName =
                                    prefs.getString("username") ?? "";

                                CreateJobsRequest rawModel = CreateJobsRequest(
                                    title: title.text,
                                    location: location.text,
                                    company: company.text,
                                    hiring: true,
                                    description: description.text,
                                    salary: salary.text,
                                    period: period.text,
                                    contract: contract.text,
                                    imageUrl: skillsNotifier.logoUrl,
                                    agentId: userUid,
                                    requirements: [
                                      rq1.text,
                                      rq2.text,
                                      rq3.text,
                                      rq4.text,
                                      rq5.text,
                                    ],
                                    agentName: agentName);

                                var model = createJobsRequestToJson(rawModel);

                                JobsHelper.createJob(model);
                                zoomNotifier.currentIndex = 0;
                                Get.to(() => const Mainscreen());
                              },
                              hieght: 40.h,
                              text: "Submit",
                              color: Color(kNewBlue.value))
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}

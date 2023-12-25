import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/skills_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/auth/add_skills.dart';
import 'package:jobhubv2_0/models/response/auth/skills.dart';
import 'package:jobhubv2_0/services/helpers/auth_helper.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';
import 'package:jobhubv2_0/views/screens/auth/widgets/addSkills.dart';
import 'package:provider/provider.dart';

class SkillsWidget extends StatefulWidget {
  const SkillsWidget({super.key});

  @override
  State<SkillsWidget> createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<SkillsWidget> {
  TextEditingController userskills = TextEditingController();
  late Future<List<Skills>> userSkills;

  @override
  void initState() {
    userSkills = getSkills();
    super.initState();
  }

  Future<List<Skills>> getSkills() {
    var skills = AuthHelper.getSkills();
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    var skillsNotifier = Provider.of<SkillsNotifier>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                  text: 'Skills',
                  style: appStyle(15, Color(kDark.value), FontWeight.w600)),
              Consumer<SkillsNotifier>(
                builder: (context, skillsNotifier, child) {
                  return skillsNotifier.addSkills != true
                      ? GestureDetector(
                          onTap: () {
                            skillsNotifier.setSkills =
                                !skillsNotifier.addSkills;
                          },
                          child: const Icon(
                              MaterialCommunityIcons.plus_circle_outline,
                              size: 24),
                        )
                      : GestureDetector(
                          onTap: () {
                            skillsNotifier.setSkills =
                                !skillsNotifier.addSkills;
                          },
                          child: const Icon(AntDesign.closecircleo, size: 20),
                        );
                },
              )
            ],
          ),
        ),
        const HeightSpacer(size: 5),
        skillsNotifier.addSkills == true
            ? AddSkillsWidget(
                skill: userskills,
                onTap: () {
                  AddSkill rawModel = AddSkill(skill: userskills.text);
                  var model = addSkillToJson(rawModel);
                  AuthHelper.addSkills(model);
                  userskills.clear();
                  skillsNotifier.setSkills = !skillsNotifier.addSkills;
                  userSkills = getSkills();
                },
              )
            : SizedBox(
                height: 33.w,
                child: FutureBuilder(
                    future: userSkills,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        var skills = snapshot.data;
                        return ListView.builder(
                            itemCount: skills!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var skill = skills[index];
                              return GestureDetector(
                                onLongPress: () {
                                  skillsNotifier.setSkillsId = skill.id;
                                },
                                onTap: () {
                                  skillsNotifier.setSkillsId = '';
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.w),
                                  margin: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.w)),
                                      color: Color(kLightGrey.value)),
                                  child: Row(
                                    children: [
                                      ReusableText(
                                          text: skill.skill,
                                          style: appStyle(
                                              10,
                                              Color(kDark.value),
                                              FontWeight.w500)),
                                      const WidthSpacer(width: 5),
                                      skillsNotifier.addSkillsId == skill.id
                                          ? GestureDetector(
                                              onTap: () {
                                                AuthHelper.deleteSkill(
                                                    skillsNotifier.addSkillsId);
                                                skillsNotifier.setSkillsId = '';
                                                userSkills = getSkills();
                                              },
                                              child: Icon(
                                                AntDesign.delete,
                                                size: 14,
                                                color: Color(kDark.value),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              )
      ],
    );
  }
}

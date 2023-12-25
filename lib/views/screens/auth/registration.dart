import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/signup_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/auth/signup_model.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/custom_btn.dart';
import 'package:jobhubv2_0/views/common/custom_textfield.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/screens/auth/login.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              text: 'Sign Up',
              child: GestureDetector(
                onTap: () {
                  Get.offAll(() => const LoginPage());
                },
                child: const Icon(
                  AntDesign.leftcircleo,
                ),
              ),
            ),
          ),
          body: signUpNotifier.loader
              ? const PageLoader()
              : buildStyleContainer(
                  context,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                        child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const HeightSpacer(size: 50),
                        ReusableText(
                            text: "Welcome",
                            style: appStyle(
                                30, Color(kDark.value), FontWeight.w600)),
                        ReusableText(
                            text:
                                "Fill in the Details to sign up for aa new account.",
                            style: appStyle(
                                14, Color(kDarkGrey.value), FontWeight.w400)),
                        const HeightSpacer(size: 40),
                        CustomTextField(
                          controller: username,
                          hintText: "Fullname",
                          keyboardType: TextInputType.text,
                          validator: (username) {
                            if (username!.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 20),
                        CustomTextField(
                          controller: email,
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email!.isEmpty || !email.contains('@')) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 20),
                        CustomTextField(
                          controller: password,
                          hintText: "Password",
                          obscureText: signUpNotifier.obscureText,
                          keyboardType: TextInputType.text,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signUpNotifier.obscureText =
                                  !signUpNotifier.obscureText;
                            },
                            child: Icon(signUpNotifier.obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          validator: (password) {
                            if (password!.length < 8) {
                              return "Password should be at least 8 characters long";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.offAll(() => const LoginPage());
                            },
                            child: ReusableText(
                                text: "Already have an account? Login",
                                style: appStyle(
                                    12, Color(kDark.value), FontWeight.w400)),
                          ),
                        ),
                        const HeightSpacer(size: 30),
                        Consumer<ZoomNotifier>(
                          builder: (context, zoomNotifier, child) {
                            return CustomButton(
                              text: "Sign Up",
                              onTap: () {
                                signUpNotifier.loader = true;

                                SignupModel model = SignupModel(
                                    username: username.text,
                                    email: email.text,
                                    password: password.text);

                                String newModel = signupModelToJson(model);

                                signUpNotifier.signUp(newModel);
                              },
                            );
                          },
                        )
                      ],
                    )),
                  ),
                ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/auth/login_model.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/custom_btn.dart';
import 'package:jobhubv2_0/views/common/custom_textfield.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/screens/auth/registration.dart';
import 'package:jobhubv2_0/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, loginNotifier, child) {
        loginNotifier.getPref();
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: CustomAppBar(
                text: 'Login',
                child: GestureDetector(
                  onTap: () {
                    Get.offAll(() => const Mainscreen());
                  },
                  child: const Icon(
                    AntDesign.leftcircleo,
                  ),
                ),
              )),
          body: loginNotifier.loader
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
                            text: "Welcome Back",
                            style: appStyle(
                                30, Color(kDark.value), FontWeight.w600)),
                        ReusableText(
                            text:
                                "Fill in the Details to login to your account.",
                            style: appStyle(
                                14, Color(kDarkGrey.value), FontWeight.w400)),
                        const HeightSpacer(size: 40),
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
                          obscureText: loginNotifier.obscureText,
                          keyboardType: TextInputType.text,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              loginNotifier.obscureText =
                                  !loginNotifier.obscureText;
                            },
                            child: Icon(loginNotifier.obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          validator: (password) {
                            if (password!.isEmpty || password.length < 8) {
                              return "Please enter valid password";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.offAll(() => const RegistrationPage());
                            },
                            child: ReusableText(
                                text: "Do not have an account? Register",
                                style: appStyle(
                                    12, Color(kDark.value), FontWeight.w400)),
                          ),
                        ),
                        const HeightSpacer(size: 30),
                        Consumer<ZoomNotifier>(
                          builder: (context, zoomNotifier, child) {
                            return CustomButton(
                              text: "Login",
                              onTap: () {
                                loginNotifier.loader = true;
                                LoginModel model = LoginModel(
                                    email: email.text, password: password.text);

                                String newModel = loginModelToJson(model);

                                loginNotifier.login(newModel, zoomNotifier);

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

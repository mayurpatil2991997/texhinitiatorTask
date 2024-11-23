// login_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tech_initiator/Themes/app_colors_theme.dart';
import 'package:tech_initiator/Themes/app_text_theme.dart';
import 'package:tech_initiator/Utils/form_validate.dart';
import 'package:tech_initiator/screens/sign_up_screen.dart';
import 'package:tech_initiator/widgets/button_widget.dart';
import 'package:tech_initiator/widgets/custom_text_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // After successful login, navigate to the HomeScreen with the username
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(username: userCredential.user!.email!),
        ),
      );
    } catch (e) {
      print("Login error: $e");
      // Handle login error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Login",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
            ),
          )),
      body: Form(
        key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Enter Email",
                  controller: _emailController,
                  keyboardType: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Email";
                    } else {
                      return FormValidate.validateEmail(
                          value, "Please Enter Valid Email");
                    }
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                CustomTextField(
                  hintText: "Enter Password",
                  controller: _passwordController,
                  keyboardType: null,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Password";
                    } else {
                      return FormValidate.validatePassword(
                          value, "Please Enter Valid Password");
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                ButtonWidget(
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      _login();
                    }
                  },
                  text: "Login",
                  textStyle: AppTextStyle.mediumText
                      .copyWith(color: AppColor.whiteColor, fontSize: 16),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyle.mediumText
                          .copyWith(fontSize: 14, color: AppColor.blackColor),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: AppTextStyle.semiBoldText.copyWith(
                            fontSize: 14, color: AppColor.primaryColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
      ),
    );
  }
}

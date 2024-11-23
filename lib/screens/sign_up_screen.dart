// sign_up_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:tech_initiator/Themes/app_colors_theme.dart';
import 'package:tech_initiator/Themes/app_text_theme.dart';
import 'package:tech_initiator/Utils/form_validate.dart';
import 'package:tech_initiator/screens/login_screen.dart';
import 'package:tech_initiator/widgets/button_widget.dart';
import 'package:tech_initiator/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text,
      });
    } catch (e) {
      print("Sign-up error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Sign Up",
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
                      return FormValidate.validateEmail(
                          value, "Please Enter Valid Password");
                    }
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                CustomTextField(
                  hintText: "Enter User Name",
                  controller: _usernameController,
                  keyboardType: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter User Name";
                    } else {
                      return FormValidate.requiredField(
                          value, "Please Enter Valid User Name");
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                ButtonWidget(
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      _signUp();
                    }
                  },
                  text: "Sign Up",
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
                      "Already have an account? ",
                      style: AppTextStyle.mediumText
                          .copyWith(fontSize: 14, color: AppColor.blackColor),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: AppTextStyle.semiBoldText.copyWith(
                            fontSize: 14, color: AppColor.primaryColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}

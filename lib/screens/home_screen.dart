// home_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tech_initiator/Themes/app_colors_theme.dart';
import 'package:tech_initiator/Themes/app_text_theme.dart';
import 'package:tech_initiator/Utils/form_validate.dart';
import 'package:tech_initiator/screens/login_screen.dart';
import 'package:tech_initiator/widgets/button_widget.dart';
import 'package:tech_initiator/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void _postMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('posts').add({
        'message': _messageController.text,
        'username': widget.username,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
          child: Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: 3.w
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                CustomTextField(
                  hintText: "Type your post here",
                  controller: _messageController,
                  keyboardType: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Message";
                    } else {
                      return FormValidate.requiredField(
                          value, "Please Enter Valid Message");
                    }
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                ButtonWidget(
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      _postMessage();
                    }
                  },
                  text: "Post",
                  textStyle: AppTextStyle.mediumText
                      .copyWith(color: AppColor.whiteColor, fontSize: 16),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No posts yet.'));
                      }

                      final posts = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            title: Text(post['message']),
                            subtitle: Text(post['username']),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

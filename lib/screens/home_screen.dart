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
  bool isButtonEnabled = false;
  String? username;

  // Fetch the username from Firestore
  Future<void> _fetchUsername() async {
    try {
      // Get the current user from Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        // Check if the username field exists
        if (doc.exists) {
          setState(() {
            username = doc['username'] ?? "No Username"; // Default to "No Username" if not found
          });
        }
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  void _postMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('posts').add({
          'message': _messageController.text,
          'username': username ?? "Unknown User", // Use fetched username
          'timestamp': FieldValue.serverTimestamp(),
        });
        _messageController.clear();
      } catch (e) {
        print("Error posting message: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to post message")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsername();

    _messageController.addListener(() {
      setState(() {
        isButtonEnabled = _messageController.text.trim().isNotEmpty; // Button will be enabled if there's text
      });
    });

  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Welcome ',
                style: AppTextStyle.mediumText,
              ),
              TextSpan(
                text: username ?? 'Loading...',
                style: const TextStyle(
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
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
      body: Padding(
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
            ),
            SizedBox(
              height: 5.h,
            ),
            isButtonEnabled ? ButtonWidget(
              onTap: () {
                  _postMessage();
              },
              text: "Post",
              textStyle: AppTextStyle.mediumText
                  .copyWith(color: AppColor.whiteColor, fontSize: 16),
            ) : const SizedBox(),
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
                      var timestamp = post['timestamp'] != null
                          ? (post['timestamp'] as Timestamp).toDate()
                          : null;

                      String formattedDate = timestamp != null
                          ? "${timestamp.day}-${timestamp.month}-${timestamp.year}"
                          : "No Date";
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColor.greyColor
                          ),

                        ),
                        child: ListTile(
                          title: Text(post['message']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post['username']),
                              Text(formattedDate),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

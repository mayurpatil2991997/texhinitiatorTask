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
  final TextEditingController messageController = TextEditingController();
  bool isButtonEnabled = false;
  String? username;
  int totalPosts = 0;


  // Fetch UserName Function
  Future<void> fetchUsername() async {
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


  // PostMessage Function
  void postMessage() async {
    if (messageController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('posts').add({
          'message': messageController.text,
          'username': username ?? "Unknown User", // Use fetched username
          'timestamp': FieldValue.serverTimestamp(),
        });
        messageController.clear();
      } catch (e) {
        print("Error posting message: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to post message")));
      }
    }
  }

  //Total Post Count Function
  Future<void> getTotalPostCount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('username', isEqualTo: widget.username)
          .get();

      setState(() {
        totalPosts = snapshot.docs.length;  // Set the total post count
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsername();
    getTotalPostCount();

    messageController.addListener(() {
      setState(() {
        isButtonEnabled = messageController.text.trim().isNotEmpty; // Button will be enabled if there's text
      });
    });

  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

// HomeScreen UI
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            // Custom textField
            CustomTextField(
              hintText: "Type your post here",
              controller: messageController,
              keyboardType: null,
            ),
            SizedBox(
              height: 5.h,
            ),
            // Custom Button Widget
            isButtonEnabled ? ButtonWidget(
              onTap: () {
                  postMessage();
              },
              text: "Post",
              textStyle: AppTextStyle.mediumText
                  .copyWith(color: AppColor.whiteColor, fontSize: 16),
            ) : const SizedBox(),
            SizedBox(
              height: 2.h,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Total ',
                    style: AppTextStyle.mediumText,
                  ),
                  TextSpan(
                      text: totalPosts.toString(),
                      style: AppTextStyle.mediumText.copyWith(
                        color: AppColor.primaryColor,
                      )
                  ),
                  TextSpan(
                    text: " Posts of ",
                    style: AppTextStyle.mediumText,
                  ),
                  TextSpan(
                    text: username,
                      style: AppTextStyle.mediumText.copyWith(
                        color: AppColor.primaryColor,
                      )
                  ),
                ],
              ),
            ),

            // Post List UI
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

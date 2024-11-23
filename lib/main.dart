import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Import Sizer
import 'package:tech_initiator/screens/login_screen.dart';
import 'package:tech_initiator/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer( // Wrap MaterialApp with Sizer
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Firebase Example',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginScreen(), // This should be your login screen
        );
      },
    );
  }
}

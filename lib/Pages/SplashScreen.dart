import 'package:chaty/Pages/ChatsPage.dart';
import 'package:chaty/Pages/LoginPage.dart';
import 'package:chaty/Widgets/SplashVideo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String ID = "SplashScreen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    User? user = _auth.currentUser;
    await Future.delayed(const Duration(seconds: 2));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatsPage(email: user.email!),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff005a71),
                  Color(0xff08bab1),
                ],
              ),
            ),
            child: const SplashVideo()));
  }
}

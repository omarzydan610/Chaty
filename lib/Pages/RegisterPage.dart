import 'package:chaty/Constants.dart';
import 'package:chaty/Helpers/Snakbar.dart';
import 'package:chaty/Pages/LoginPage.dart';
import 'package:chaty/Widgets/CustomButton.dart';
import 'package:chaty/Widgets/CustomTextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String ID = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email, password, userName;
  bool isLoading = false;

  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryColor,
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
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CircularProgressIndicator(
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formkey,
              child: ListView(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Chaty",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: "Pacifico",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    onChanged: (data) {
                      userName = data;
                    },
                    text: "UserName",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    onChanged: (data) {
                      email = data;
                    },
                    text: "Email",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    onChanged: (data) {
                      password = data;
                    },
                    text: "Password",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: "Sign Up",
                    ontap: () async {
                      if (formkey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await RegisterUser();

                          ShowSnackBar(context, "Successfully Registered");
                          Navigator.pushNamed(context, LoginPage.ID);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            ShowSnackBar(context, "The email is already used");
                          } else if (e.code == "network-request-failed") {
                            ShowSnackBar(context,
                                'Check Your Internet Connectoion and try again');
                          }
                        }
                        isLoading = false;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?  ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 63, 68),
                              fontSize: 16),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterUser() async {
    FirebaseFirestore.instance.collection('users').doc(email).set({
      'email': email,
      'username': userName,
      'createdat': DateTime.now(),
    });
  }
}

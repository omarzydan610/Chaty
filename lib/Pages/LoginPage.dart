import 'package:chaty/Pages/ChatsPage.dart';
import 'package:chaty/Pages/RegisterPage.dart';
import 'package:chaty/Widgets/CustomButton.dart';
import 'package:chaty/Widgets/CustomTextFormField.dart';
import 'package:chaty/Helpers/Snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static String ID = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff005a71),
              Color(0xff08bab1),
            ],
          )),
          child: ModalProgressHUD(
            progressIndicator: const CircularProgressIndicator(
              color: Colors.blue,
            ),
            inAsyncCall: isLoading,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                      "Login",
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
                      height: 60,
                    ),
                    CustomButton(
                      text: "Sign In",
                      ontap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await LoginUser();
                            ShowSnackBar(context, "Successfully Signed In");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatsPage(email: email!);
                                },
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'too-many-requests') {
                              ShowSnackBar(context,
                                  "You entered a wrong password many times,please try again later");
                            } else if (e.code == "network-request-failed") {
                              ShowSnackBar(context,
                                  'Check Your Internet Connectoion and try again');
                            } else {
                              ShowSnackBar(context, 'Wrong Email or Password');
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.ID);
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 63, 68),
                              fontSize: 16,
                            ),
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
      ),
    );
  }

  Future<void> LoginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}

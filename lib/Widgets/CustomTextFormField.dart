import 'package:chaty/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {required this.text,
      super.key,
      required this.onChanged,
      this.controller});
  final String text;
  Function(String) onChanged;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: text == "Password" ? true : false,
      controller: controller,
      onChanged: onChanged,
      validator: (data) {
        if (data!.isEmpty) {
          return 'This filed is required';
        }
        if (text == "Email") {
          if (!emailRegex.hasMatch(data)) {
            return 'Not valid email';
          }
        }
        if (text == "Password") {
          if (data.length < 6) {
            return "Password should be at least 6 Characters";
          }
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 6, 59, 64),
            width: 1.5,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }

  Future<List<String>> getAllUsernames() async {
    List<String> usernames = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in querySnapshot.docs) {
      usernames.add(doc['userName']);
    }

    return usernames;
  }
}

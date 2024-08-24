import 'package:chaty/Constants.dart';
import 'package:chaty/Helpers/Snakbar.dart';
import 'package:chaty/Helpers/ThemeNotifier.dart';
import 'package:chaty/Pages/LoginPage.dart';
import 'package:chaty/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class menu extends StatefulWidget {
  const menu({
    super.key,
    required this.menuPosition,
    required this.email,
    required this.userName,
  });
  final String email, userName;
  final double menuPosition;

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  bool darkmode = (isDark == darkMode);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: widget.menuPosition,
      top: 0,
      bottom: 0,
      width: 250,
      child: GestureDetector(
        onTap: () {},
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "@${widget.userName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.email,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "Dark Mode",
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Switch(
                      value: darkmode,
                      onChanged: (value) {
                        darkmode = !(darkmode);
                        if (isDark == darkMode) {
                          isDark == lightMode;
                        } else {
                          isDark == darkMode;
                        }
                        setState(() {});
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .toggleTheme();
                      },
                      activeColor: Colors.white,
                      activeTrackColor: KPrimaryColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    ShowSnackBar(context, "Signed Out");
                    Navigator.pushNamed(context, LoginPage.ID);
                  },
                  child: Container(
                    child: const Row(
                      children: [
                        Text(
                          "Sign Out  ",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(Icons.logout)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

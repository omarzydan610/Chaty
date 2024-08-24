import 'package:chaty/Constants.dart';

import 'package:chaty/Widgets/ChatCard.dart';
import 'package:chaty/Widgets/menu.dart';
import 'package:chaty/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({super.key, required this.email});
  static String ID = "ChatsPage";
  final String email;

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with SingleTickerProviderStateMixin {
  bool isMenuVisible = false;
  double menuPosition = -250.0;
  double shadeOpacity = 0.0;
  late Future<DocumentSnapshot> userName;
  late Stream<QuerySnapshot> UsersStream, MessagesStream;

  void initState() {
    super.initState();
    UsersStream = FirebaseFirestore.instance
        .collection('users')
        .orderBy("createdat")
        .snapshots();
    userName = getUserName(widget.email);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder<DocumentSnapshot>(
        future: userName,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              )),
            );
          } else {
            void toggleMenu() {
              setState(() {
                menuPosition = 0;
                shadeOpacity = 0.5;
                isMenuVisible = true;
              });
            }

            void hideMenu() {
              setState(() {
                menuPosition = -250;
                shadeOpacity = 0;
                isMenuVisible = false;
              });
            }

            return Scaffold(
              appBar: AppBar(
                backgroundColor: KPrimaryColor,
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    if (isMenuVisible) {
                      hideMenu();
                    } else {
                      toggleMenu();
                    }
                  },
                  icon: const Icon(Icons.menu),
                ),
                title: const Text(
                  "Chats",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: "Pacifico",
                  ),
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  if (isMenuVisible) hideMenu();
                },
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta! > 30) {
                    if (!isMenuVisible) {
                      toggleMenu();
                    }
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < -500) {
                    if (isMenuVisible) {
                      hideMenu();
                    }
                  }
                },
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: UsersStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<UserModel> Users = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            Users.add(
                              UserModel.fromJson(snapshot.data!.docs[i]),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              itemCount: Users.length,
                              itemBuilder: (contex, index) {
                                if (Users[index].Email == widget.email) {
                                  return const SizedBox();
                                } else {
                                  return ChatCard(
                                    Users: Users,
                                    index: index,
                                    from: widget.email,
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: AnimatedOpacity(
                        opacity: shadeOpacity,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        child: Container(
                          color: Colors.black,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    menu(
                      menuPosition: menuPosition,
                      email: widget.email,
                      userName: snapshot.data!['username'],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getUserName(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .get();
  }
}

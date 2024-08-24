import 'package:chaty/Constants.dart';
import 'package:chaty/Models/MessageModel.dart';
import 'package:chaty/Models/UserModel.dart';
import 'package:chaty/Widgets/ChatBubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConversationPage extends StatelessWidget {
  ConversationPage({super.key, required this.To, required this.From});
  static String ID = "ChatPAge";
  String From;
  UserModel To;

  CollectionReference messages =
      FirebaseFirestore.instance.collection("messages");
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  Stream<QuerySnapshot> MessagesStream = FirebaseFirestore.instance
      .collection("messages")
      .orderBy("sentAt", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    void HandleSubmition(String data) {
      if (data.isEmpty) {
        return;
      }
      messages.add({
        "message": data,
        "from": From,
        "to": To.Email,
        "sentAt": DateTime.now()
      });
      controller.clear();
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: MessagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> MessagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            MessagesList.add(
              Message.fromJson(snapshot.data!.docs[i]),
            );
          }
          List<Message> filteredMessages = [];
          filteredMessages = MessagesList.where(
            (message) {
              return ((message.From == From && message.To == To.Email) ||
                  (message.From == To.Email && message.To == From));
            },
          ).toList();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: KPrimaryColor,
              centerTitle: true,
              title: Text(
                "@${To.UserName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // Navigate back to the previous screen
                  Navigator.pop(context);
                },
              ),
            ),
            body: filteredMessages.isEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Start Conversation with @${To.UserName}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16.0,
                          left: 16,
                          bottom: 16,
                        ),
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            controller: controller,
                            onSubmitted: (data) {
                              HandleSubmition(data);
                            },
                            decoration: InputDecoration(
                              hintText: "Send a Message",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  HandleSubmition(controller.text);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: KSecColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: KPrimaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: KSecColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          itemCount: filteredMessages.length,
                          itemBuilder: (context, index) {
                            return ChatBubble(
                              message: filteredMessages[index],
                              email: From,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16.0,
                          left: 16,
                          bottom: 16,
                        ),
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            controller: controller,
                            onSubmitted: (data) {
                              HandleSubmition(data);
                            },
                            decoration: InputDecoration(
                              hintText: "Send a Message",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  HandleSubmition(controller.text);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: KSecColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: KPrimaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: KSecColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }
      },
    );
  }
}

import 'package:chaty/Constants.dart';
import 'package:chaty/Models/MessageModel.dart';
import 'package:chaty/Models/UserModel.dart';
import 'package:chaty/Pages/ConversationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  ChatCard({
    super.key,
    required this.Users,
    required this.index,
    required this.from,
  });

  final List<UserModel> Users;
  final int index;
  final String from;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late Stream MessagesStream;
  @override
  void initState() {
    MessagesStream = FirebaseFirestore.instance
        .collection("messages")
        .orderBy("sentAt", descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ConversationPage(
                  To: widget.Users[widget.index],
                  From: widget.from,
                );
              },
            ),
          );
        },
        child: Column(
          children: [
            Container(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "@${widget.Users[widget.index].UserName}",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: StreamBuilder(
                  stream: MessagesStream,
                  builder: (contex, snapshot) {
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
                          return ((message.From == widget.from &&
                                  message.To ==
                                      widget.Users[widget.index].Email) ||
                              (message.From ==
                                      widget.Users[widget.index].Email &&
                                  message.To == widget.from));
                        },
                      ).toList();
                      return Row(
                        children: [
                          Text(
                            filteredMessages.isEmpty
                                ? "Tap to start chat"
                                : filteredMessages[0].From == widget.from
                                    ? "You: "
                                    : "${widget.Users[widget.index].UserName}: ",
                            style: const TextStyle(
                                color: KPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                filteredMessages.isEmpty
                                    ? ""
                                    : filteredMessages[0].message),
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: const CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const Divider(
              color: KPrimaryColor,
            ),
          ],
        ));
  }
}

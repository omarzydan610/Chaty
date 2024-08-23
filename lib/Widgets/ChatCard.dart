import 'package:chaty/Constants.dart';
import 'package:chaty/Models/MessageModel.dart';
import 'package:chaty/Models/UserModel.dart';
import 'package:chaty/Pages/ConversationPage.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  ChatCard(
      {super.key,
      required this.Users,
      required this.index,
      required this.from,
      required this.MessagesStream});

  final List<UserModel> Users;
  final int index;
  final String from;
  final Stream MessagesStream;

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
                  To: Users[index],
                  From: from,
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
                  "@${Users[index].UserName}",
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
                          return ((message.From == from &&
                                  message.To == Users[index].Email) ||
                              (message.From == Users[index].Email &&
                                  message.To == from));
                        },
                      ).toList();
                      return Row(
                        children: [
                          Text(
                            filteredMessages.isEmpty
                                ? "Tap to start chat"
                                : filteredMessages[0].From == from
                                    ? "You: "
                                    : "${Users[index].UserName}: ",
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

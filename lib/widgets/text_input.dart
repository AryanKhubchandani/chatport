import 'package:chatport/services/firebase_db.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String myNumber, chatRoomId;
  TextInput(this.myNumber, this.chatRoomId);

  TextEditingController textController = TextEditingController();

  addMessage(bool send) {
    if (textController.text != "") {
      String message = textController.text;

      var lastMessageTime = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "content": message,
        "sentBy": myNumber,
        "timestamp": lastMessageTime,
      };
      DatabaseMethods().addMessage(chatRoomId, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageTime": lastMessageTime,
          "lastMessageSentby": myNumber,
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (send) {
          textController.text = "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              )
            ]),
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textController,
                    onSubmitted: (value) {
                      addMessage(true);
                    },
                    decoration: const InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    addMessage(true);
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

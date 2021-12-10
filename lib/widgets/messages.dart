import 'package:chatport/models/message.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: messages.length,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index) {
          return Container(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: (messages[index].isSender
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start),
              children: [
                if (!messages[index].isSender) ...[
                  const CircleAvatar(
                    radius: 12.0,
                    backgroundImage: NetworkImage(""),
                  ),
                  const SizedBox(
                    width: 5.0,
                  )
                ],
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: (messages[index].isSender
                        ? Colors.blue
                        : Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    messages[index].content,
                    style: TextStyle(
                        fontSize: 15,
                        color: messages[index].isSender
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

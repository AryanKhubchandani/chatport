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
        // itemCount: messages.length,
        itemCount: 1,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index) {
          return Container(
              // padding:
              //     const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
              // child: Row(
              //   mainAxisAlignment: (messages[index].isSender
              //       ? MainAxisAlignment.end
              //       : MainAxisAlignment.start),
              //   children: [
              //     if (!messages[index].isSender) ...[
              //       const CircleAvatar(
              //         radius: 12.0,
              //         backgroundImage: NetworkImage(""),
              //       ),
              //       const SizedBox(
              //         width: 5.0,
              //       )
              //     ],
              //     Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(25),
              //         color: (messages[index].isSender
              //             ? Colors.blue
              //             : Colors.grey.shade300),
              //       ),
              //       padding: const EdgeInsets.all(12),
              //       child: Text(
              //         messages[index].content,
              //         style: TextStyle(
              //             fontSize: 15,
              //             color: messages[index].isSender
              //                 ? Colors.white
              //                 : Colors.black),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 5.0,
              //     ),
              //     if (messages[index].isSender) ...[
              //       Container(
              //         height: 15.0,
              //         width: 15.0,
              //         decoration: BoxDecoration(
              //           color: statusColor(messages[index].status),
              //           shape: BoxShape.circle,
              //         ),
              //         child: Icon(
              //             messages[index].status == MessageStatus.not_sent
              //                 ? Icons.close
              //                 : Icons.done,
              //             color: Colors.white,
              //             size: 10.0),
              //       ),
              //     ],
              //   ],
              // ),
              );
        },
      ),
    );
  }
}

Color statusColor(MessageStatus status) {
  switch (status) {
    case MessageStatus.not_sent:
      return Colors.red;
    case MessageStatus.sent:
      return Colors.grey;
    case MessageStatus.viewed:
      return Colors.blue;
    default:
      return Colors.transparent;
  }
}

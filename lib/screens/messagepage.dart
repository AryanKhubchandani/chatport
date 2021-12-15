import 'package:chatport/services/firebase_db.dart';
import 'package:chatport/services/sharedpref.dart';
import 'package:chatport/widgets/text_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  final String chatWithNumber, name, image;
  MessagePage(
    this.chatWithNumber,
    this.name,
    this.image,
  );

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  String chatRoomId = '';
  late Stream<QuerySnapshot> messageStream;
  late String myName, myImage, myNumber = '';

  getInfo() async {
    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myImage = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myNumber = (await SharedPreferenceHelper().getPhoneNumber())!;

    chatRoomId = getChatRoomID(widget.chatWithNumber, myNumber);
  }

  getChatRoomID(String a, b) {
    if (int.parse(a) > int.parse(b)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        bool isSender = false;
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        if (myNumber == ds['sentBy']) {
                          isSender = true;
                        }
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: (isSender
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start),
                            children: [
                              if (!isSender) ...[
                                CircleAvatar(
                                  radius: 12.0,
                                  backgroundImage: NetworkImage(widget.image),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                )
                              ],
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: (isSender
                                      ? Colors.indigo
                                      : Colors.grey.shade300),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  ds["content"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: isSender
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 5.0,
                              // ),
                              // if (isSender) ...[
                              //   Container(
                              //     height: 15.0,
                              //     width: 15.0,
                              //     decoration: BoxDecoration(
                              //       color: statusColor(messages[index].status),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: Icon(
                              //         messages[index].status ==
                              //                 MessageStatus.not_sent
                              //             ? Icons.close
                              //             : Icons.done,
                              //         color: Colors.white,
                              //         size: 10.0),
                              //   ),
                              // ],
                            ],
                          ),
                        );
                      }),
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  getMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  dothisOnLaunch() async {
    await getInfo();
    getMessages();
  }

  @override
  void initState() {
    dothisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            const BackButton(),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
              maxRadius: 20,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    "Online",
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          chatMessages(),
          TextInput(myNumber, chatRoomId),
        ],
      ),
    );
  }
}

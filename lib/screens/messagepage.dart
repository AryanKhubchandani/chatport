import 'package:chatport/services/sharedpref.dart';
import 'package:chatport/widgets/messages.dart';
import 'package:chatport/widgets/text_input.dart';
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
  late String myName, myImage, myNumber = '';

  getInfo() async {
    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myImage = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myNumber = (await SharedPreferenceHelper().getPhoneNumber())!;

    chatRoomId = getChatRoomID(widget.chatWithNumber, myNumber);
  }

  getChatRoomID(String a, b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getMessages() async {}

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
          Messages(),
          TextInput(myNumber, chatRoomId),
        ],
      ),
    );
  }
}

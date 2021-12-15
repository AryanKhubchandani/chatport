import 'package:chatport/screens/messagepage.dart';
import 'package:chatport/services/firebase_db.dart';
import 'package:chatport/services/sharedpref.dart';
import 'package:chatport/widgets/chat_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool onSearching = false;
  bool onSearched = false;
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> userStream, chatUserStream;
  late String myName, myImage, myNumber;

  getInfo() async {
    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myImage = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myNumber = (await SharedPreferenceHelper().getPhoneNumber())!;
  }

  getChatRoomID(String a, b) {
    if (int.parse(a) > int.parse(b)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearch() async {
    onSearching = true;
    userStream =
        await DatabaseMethods().getUserByPhoneNumber(searchController.text);
    setState(() {
      // searchUsers();
    });
  }

  Widget searchUserTile({name, image, number}
      /*, message, time, online, bool isMessageRead*/
      ) {
    if (name != "") {
      return InkWell(
        onTap: () {
          var chatRoomId = getChatRoomID(myNumber, number);

          Map<String, dynamic> chatRoomInfoMap = {
            "users": [myNumber, number]
          };
          DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MessagePage(number, name, image);
              },
            ),
          );
        },
        child: ChatBox(
          name: name,
          number: number,
          message:
              "Hey,f dksfj;dalsk fjldksa jaf;ldskj flkdsaj f;ol fkdsj ;fdklsj",
          image: image,
          time: "5",
          online: true,
          isMessageRead: false,
        ),
      );
    } else
      return Container();
  }

  Widget searchUsers() {
    return StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return searchUserTile(
                        name: ds['name'],
                        image: ds['imgUrl'],
                        number: ds['phoneNumber']);
                  })
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget chatUsers() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatUserStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 15),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return ChatTile(ds.id, ds['lastMessage'], myNumber);
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  getChatStream() async {
    chatUserStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getInfo();
    getChatStream();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Chats",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Number...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    suffixIcon: onSearching
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            color: Colors.grey[600],
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                onSearching = false;
                                onSearched = false;
                                FocusManager.instance.primaryFocus!.unfocus();
                                searchController.text = "";
                              });
                            })
                        : null,
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.all(8.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      onSearching = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        onSearched = true;
                        onSearch();
                      }
                    });
                  },
                ),
              ),
              onSearched ? searchUsers() : chatUsers(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatefulWidget {
  final String chatId, message, myNumber;

  ChatTile(this.chatId, this.message, this.myNumber);
  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  String uImgUrl = '', uName = '', uNumber = '';
  getThisUserInfo() async {
    uNumber = widget.chatId.replaceAll(widget.myNumber, "").replaceAll("_", "");

    QuerySnapshot query = await DatabaseMethods().getUserInfo(uNumber);
    uName = query.docs[0]['name'];
    uImgUrl = query.docs[0]['imgUrl'];

    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MessagePage(uNumber, uName, uImgUrl);
            },
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(uImgUrl),
                        maxRadius: 30,
                      ),
                      // if (widget.online == true)
                      //   Container(
                      //     height: 15,
                      //     width: 16,
                      //     decoration: BoxDecoration(
                      //         color: Colors.green,
                      //         shape: BoxShape.circle,
                      //         border: Border.all(
                      //           color: Colors.white,
                      //           width: 2.0,
                      //         )),
                      //   ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              uName,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                // fontWeight: widget.isMessageRead
                                //     ? FontWeight.bold
                                //     : FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   widget.time,
            //   style: TextStyle(
            //       fontSize: 12,
            //       fontWeight:
            //           widget.isMessageRead ? FontWeight.bold : FontWeight.normal),
            // ),
          ],
        ),
      ),
    );
  }
}

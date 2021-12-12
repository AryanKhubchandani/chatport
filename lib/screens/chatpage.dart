import 'package:chatport/services/firebase_db.dart';
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
  late Stream<QuerySnapshot> userStream;

  onSearch() async {
    onSearching = true;
    userStream =
        await DatabaseMethods().getUserByPhoneNumber(searchController.text);
    setState(() {
      // searchUsers();
    });
  }

  Widget searchUserTile(
      String name, image /*, message, time, online, bool isMessageRead*/) {
    if (name != "") {
      return ChatBox(
          name: name,
          message:
              "Hey,f dksfj;dalsk fjldksa jaf;ldskj flkdsaj f;ol fkdsj ;fdklsj",
          image: image,
          time: "5",
          online: true,
          isMessageRead: false);
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
                    return searchUserTile(ds['name'], ds['imgUrl']);
                  })
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget chatUsers() {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 15),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, index) => ChatBox(
          name: "Aryan",
          message:
              "Hey,f dksfj;dalsk fjldksa jaf;ldskj flkdsaj f;ol fkdsj ;fdklsj",
          image: "image",
          time: "5",
          online: true,
          isMessageRead: false),
    );
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Chats",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.person_add,
                        ),
                        mini: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search...",
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
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      onSearching = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      onSearched = true;
                      onSearch();
                    });
                  },
                ),
              ),
              onSearched ? searchUsers() : chatUsers(),
              // ListView.builder(
              //   itemCount: 10,
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.only(top: 15),
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (BuildContext context, index) => ChatBox(
              //       name: "Aryan",
              //       message:
              //           "Hey,f dksfj;dalsk fjldksa jaf;ldskj flkdsaj f;ol fkdsj ;fdklsj",
              //       image: "image",
              //       time: "5",
              //       online: true,
              //       isMessageRead: false),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

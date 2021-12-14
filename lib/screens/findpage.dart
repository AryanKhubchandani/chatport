import 'package:chatport/screens/messagepage.dart';
import 'package:chatport/services/firebase_db.dart';
import 'package:chatport/services/sharedpref.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindPage extends StatefulWidget {
  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  bool onSearching = false;
  bool onSearched = false;
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> userStream, findUserStream;
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
    setState(() {});
  }

  Widget searchUserTile({name, image, number}) {
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
        child: UserTile(number),
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

  Widget findUsers() {
    return StreamBuilder<QuerySnapshot>(
        stream: findUserStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 15),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return UserTile(ds['phoneNumber']);
                  })
              : const Center(child: CircularProgressIndicator());
        });
  }

  FindUsersStream() async {
    findUserStream = await DatabaseMethods().getUsers();
    setState(() {});
  }

  onScreenLoaded() async {
    await getInfo();
    FindUsersStream();
  }

  @override
  void initState() {
    onScreenLoaded();
    // getThisUserInfo();
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
                    "Users",
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
                      if (value.isNotEmpty) {
                        onSearched = true;
                        onSearch();
                      }
                    });
                  },
                ),
              ),
              onSearched ? searchUsers() : findUsers(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatefulWidget {
  final String number;

  UserTile(this.number);
  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<UserTile> {
  String uImgUrl = '', uName = '', uNumber = '';
  getThisUserInfo() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .where('phoneNumber', isEqualTo: widget.number)
        .get();
    uNumber = query.docs[0]['phoneNumber'];
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
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              uNumber,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
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
          ],
        ),
      ),
    );
  }
}

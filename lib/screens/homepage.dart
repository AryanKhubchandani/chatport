import 'package:chatport/screens/chatpage.dart';
import 'package:chatport/screens/findpage.dart';
import 'package:chatport/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _page = 1;
  late PageController _c;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    _c = PageController(
      keepPage: true,
      initialPage: _page,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isOnline': 'online'});
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isOnline': 'offline'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
        selectedIconTheme: IconThemeData(color: _getColor()),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _page,
        selectedItemColor: _getColor(),
        onTap: (index) {
          _c.animateToPage(index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutSine);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Find',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: PageView(
        controller: _c,
        onPageChanged: (newPage) {
          setState(() {
            _page = newPage;
          });
        },
        children: <Widget>[FindPage(), ChatPage(), SettingsPage()],
      ),
    );
  }

  Color _getColor() {
    switch (_page) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.black;
      default:
        return Colors.blue;
    }
  }
}

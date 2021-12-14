import 'dart:io';

import 'package:chatport/screens/loginpage.dart';
import 'package:chatport/services/firebase_db.dart';
import 'package:chatport/services/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController nameController = TextEditingController();
  String myName = '', myImage = '', myNumber = '';
  getInfo() async {
    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myImage = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myNumber = (await SharedPreferenceHelper().getPhoneNumber())!;
  }

  String url = '';

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _upload() async {
    final picker = ImagePicker();

    PickedFile? pickedImage;
    try {
      pickedImage = await picker.getImage(
        source: ImageSource.gallery,
      );

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        Reference ref = storage.ref().child(myNumber);

        UploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.whenComplete(() async {
          url = await ref.getDownloadURL();
          updateImg();
          setState(() {});
        }).catchError((onError) {
          print(onError);
        });
        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
    setState(() {});
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: InkWell(
                      onTap: () {
                        _upload();
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(myImage),
                        radius: 50,
                      ),
                    ),
                  ),
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: myName,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          updateName();
                          setState(() {});
                        }
                      }),
                  const SizedBox(height: 100.0),
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: myNumber,
                    ),
                  ),
                  const SizedBox(height: 120.0),
                  ElevatedButton(
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.of(context).popUntil((route) => false);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => const LoginPage()));
                      },
                      child: const Text("LOG OUT")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateImg() async {
    await SharedPreferenceHelper().saveUserProfileUrl(url);

    FirebaseFirestore.instance
        .collection("users")
        .doc(myNumber)
        .update({'imgUrl': SharedPreferenceHelper().getUserProfileUrl()});
  }

  void updateName() async {
    await SharedPreferenceHelper().saveDisplayName(nameController.text);
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'name': nameController.text});
  }
}

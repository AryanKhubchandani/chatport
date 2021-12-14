import 'dart:io';

import 'package:chatport/screens/homepage.dart';
import 'package:chatport/services/firebase_db.dart';
import 'package:chatport/services/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  final String phoneNumber;

  const ProfilePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  DocumentReference sightingRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  String url = '';
  bool isUrlEmpty = true;

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
        Reference ref = storage.ref().child(widget.phoneNumber);

        UploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.whenComplete(() async {
          url = await ref.getDownloadURL();
          SharedPreferenceHelper().saveUserProfileUrl(url);
          setState(() {});
        }).catchError((onError) {
          print(onError);
        });
        setState(() {
          isUrlEmpty = false;
        });
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: <Widget>[
            const Text(
              "Build your Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Please provide your name and a profile picture",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            inputBox(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: submitProfile,
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget inputBox() {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            _upload();
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.shade200, shape: BoxShape.circle),
            child: isUrlEmpty
                ? const Icon(Icons.camera_alt, color: Colors.blue)
                : CircleAvatar(backgroundImage: NetworkImage(url)),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Enter your name",
            ),
          ),
        ),
      ],
    );
  }

  void submitProfile() async {
    if (_nameController.text.isNotEmpty) {
      Map<String, dynamic> userInfoMap = {
        'phoneNumber': widget.phoneNumber,
        'name': _nameController.text,
        'imgUrl': url,
      };
      SharedPreferenceHelper().saveDisplayName(_nameController.text);
      DatabaseMethods()
          .updateUserInfoToDB(
              FirebaseAuth.instance.currentUser!.uid, userInfoMap)
          .then((value) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (c) => const HomePage()),
        );
      });
    }
  }
}

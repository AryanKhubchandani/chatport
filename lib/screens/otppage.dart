import 'package:chatport/screens/profilepage.dart';
import 'package:chatport/services/firebase_db.dart';
import 'package:chatport/services/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:chatport/screens/homepage.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String code;

  OTPScreen({required this.phone, required this.code});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  String? verificationCode;

  final BoxDecoration otpDecoration = BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.grey,
    ),
  );

  @override
  void initState() {
    super.initState();
    sendOTP();
  }

  sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.code + widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential).then(
            (value) {
              User userDetails = value.user as User;
              if (value.user != null) {
                SharedPreferenceHelper().saveUserId(userDetails.uid);
                SharedPreferenceHelper()
                    .savePhoneNumber(userDetails.phoneNumber.toString());
                SharedPreferenceHelper()
                    .saveDisplayName(userDetails.displayName.toString());
                SharedPreferenceHelper()
                    .saveUserProfileUrl(userDetails.photoURL.toString());

                Map<String, dynamic> userInfoMap = {
                  "phoneNumber": userDetails.phoneNumber,
                  "name": userDetails.displayName,
                  "imgUrl": userDetails.photoURL
                };
                DatabaseMethods()
                    .addUserInfoToDB(userDetails.uid, userInfoMap)
                    .then((value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (c) => ProfilePage(
                              phoneNumber: widget.code + widget.phone,
                            )),
                  );
                });
              }
            },
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        codeSent: (String vID, int? resendToken) {
          setState(() {
            verificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationCode = vID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      key: _scaffoldkey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                "Verification for: ${widget.code}-${widget.phone}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
              eachFieldHeight: 55.0,
              eachFieldWidth: 40.0,
              focusNode: _otpFocus,
              controller: _otpController,
              submittedFieldDecoration: otpDecoration,
              selectedFieldDecoration: otpDecoration,
              followingFieldDecoration: otpDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode!, smsCode: pin))
                      .then(
                    (value) {
                      User userDetails = value.user as User;
                      if (value.user != null) {
                        // SharedPreferenceHelper()
                        // .saveUserEmail(userDetails.email.toString());
                        SharedPreferenceHelper().saveUserId(userDetails.uid);
                        // SharedPreferenceHelper()
                        //     .saveUserName(userDetails.email.replaceAll("@gmail.com", ""));
                        SharedPreferenceHelper().savePhoneNumber(
                            userDetails.phoneNumber.toString());
                        SharedPreferenceHelper().saveDisplayName(
                            userDetails.displayName.toString());
                        SharedPreferenceHelper().saveUserProfileUrl(
                            userDetails.photoURL.toString());

                        Map<String, dynamic> userInfoMap = {
                          "phoneNumber": userDetails.phoneNumber,
                          "name": userDetails.displayName,
                          "imgUrl": userDetails.photoURL
                        };
                        DatabaseMethods()
                            .addUserInfoToDB(userDetails.uid, userInfoMap)
                            .then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (c) => ProfilePage(
                                      phoneNumber: widget.code + widget.phone,
                                    )),
                          );
                        });
                      }
                    },
                  );
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid OTP"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                sendOTP();
              },
              child: const Text(
                "Verify",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //get current user
  getCurrentUser() async {
    return auth.currentUser;
  }
}

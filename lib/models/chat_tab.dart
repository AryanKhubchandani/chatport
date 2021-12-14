import 'package:flutter/material.dart';

class ChatUsers {
  String id;
  String name;
  String message;
  String image;
  String time;
  bool online;
  ChatUsers(
      {required this.id,
      required this.name,
      required this.message,
      required this.image,
      required this.time,
      required this.online});
}

// class ChatUsers {
//   String id;
//   // String idTo;
//   String name;
//   String message;
//   String image;
//   String time;
//   bool online;
//   ChatUsers(
//       {required this.id,
//       // required this.idTo,
//       required this.name,
//       required this.message,
//       required this.image,
//       required this.time,
//       required this.online});

//   // factory ChatUsers.fromMap(Map<String, dynamic> data) {
//   //   return ChatUsers(
//   //     idFrom: data['idFrom'],
//   //     idTo: data['idTo'],
//   //     name: data['name'],
//   //     message: data['message'],
//   //     image: data['image'],
//   //     time: data['time'],
//   //     online: data['online '],
//   //   );
//   // }
//   Map<dynamic, dynamic>   toJson() {
//     return {
//       id: id,
//       name: name,
//       message: message,
//       image: image,
//       time: time,
//       online: online,
//     };
//   }

//   factory ChatUsers.fromDocument(DocumentSnapshot doc) {
//     String id = "";
//     String name = "";
//     String message = "";
//     String image = "";
//     String time = "";
//     String online = "";

//     try {
//       id = doc.get("id");
//     } catch (e) {}
//     try {
//       name = doc.get("name");
//     } catch (e) {}
//     try {
//       message = doc.get('message');
//     } catch (e) {}
//     try {
//       image = doc.get('imgUrl');
//     } catch (e) {}
//     try {
//       time = doc.get('time');
//     } catch (e) {}
//     return ChatUsers(
//       id: doc.id,
//       image: image,
//     );
//   }
// }

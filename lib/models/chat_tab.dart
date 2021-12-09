import 'package:flutter/material.dart';

class ChatUsers {
  String name;
  String message;
  String image;
  String time;
  bool online;
  ChatUsers(
      {required this.name,
      required this.message,
      required this.image,
      required this.time,
      required this.online});
}

import 'package:flutter/material.dart';

enum MessageStatus { not_sent, sent, viewed }

class ChatMessage {
  String content;
  MessageStatus status;
  bool isSender;
  ChatMessage(
      {required this.content, required this.status, required this.isSender});
}

List messages = [
  ChatMessage(
      content: "content", status: MessageStatus.viewed, isSender: false),
  ChatMessage(content: "content", status: MessageStatus.viewed, isSender: true),
  ChatMessage(content: "OK", status: MessageStatus.viewed, isSender: false),
  ChatMessage(content: "content", status: MessageStatus.viewed, isSender: true),
  ChatMessage(content: "OK", status: MessageStatus.viewed, isSender: false),
  ChatMessage(content: "content", status: MessageStatus.viewed, isSender: true),
  ChatMessage(
      content: "content", status: MessageStatus.viewed, isSender: false),
  ChatMessage(content: "OK", status: MessageStatus.viewed, isSender: true),
  ChatMessage(content: "OK", status: MessageStatus.viewed, isSender: false),
  ChatMessage(content: "content", status: MessageStatus.viewed, isSender: true),
  ChatMessage(content: "content", status: MessageStatus.sent, isSender: true),
  ChatMessage(content: "OK", status: MessageStatus.not_sent, isSender: true),
];

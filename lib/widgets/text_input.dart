import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              )
            ]),
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

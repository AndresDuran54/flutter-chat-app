import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String text, uid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.uid,
    required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.slowMiddle),
        child: Container(
          child: (uid == '123')?
            _myMessage()
            : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(
          top: 5, 
          bottom: 5,
          left: 50
        ),
        padding: const EdgeInsetsDirectional.all(8),
        child: Text(text, style: const TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xff4D9EF6)
        ),
      ),
    );
  }

  Widget _notMyMessage(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          top: 5, 
          bottom: 5,
          right: 50
        ),
        padding: const EdgeInsetsDirectional.all(8),
        child: Text(text, style: const TextStyle(color: Colors.black54)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xffE4E5E8)
        ),
      ),
    );
  }
}
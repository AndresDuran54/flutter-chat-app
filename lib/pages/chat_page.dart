import 'dart:io';

import 'package:chat/widgets/chat_mesage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}  

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode =  FocusNode();

  final List<ChatMessage> _messages = [
  ];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: const <Widget>[
            CircleAvatar(
              child: Text('An'),
              maxRadius: 13,
            ),
            SizedBox(height: 3),
            Text('Andrés Duran Ccota', style: TextStyle(color: Colors.black))
          ],
        ),
        centerTitle: true,
        elevation: 1
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            //Un widget que controla cómo se flexiona un hijo de Row, Column o Flex.
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                //Que empiecé mostrando el último item
                reverse: true,
                itemBuilder: (BuildContext context, int i) => _messages[i]
              ) 
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      )
    );
  }

  Widget _inputChat(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: (String _){
          
              },
              onChanged: (String texto){
                if(texto.trim().length > 0){
                  _estaEscribiendo = true;
                }else{
                  _estaEscribiendo = false;
                }
                setState(() {
                  
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Enviar mensaje',
              ),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS? 
              CupertinoButton(
                child: const Text('Enviar'), 
                onPressed: _estaEscribiendo? 
                      () => _handleSubmit(_textController.text.trim())
                      : null
              )
              :
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.blueAccent),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: _estaEscribiendo? 
                      () => _handleSubmit(_textController.text.trim())
                      : null, 
                    icon: const Icon(Icons.send)
                  ),
                )
              )
          )
        ],
      ),      
    );
  }

  _handleSubmit(String texto){

    if(texto.length == 0) return;

    final newMessage = ChatMessage(
      text: texto, 
      uid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
    _focusNode.requestFocus();
    _textController.clear();
  }

  //Se llama cuando este objeto se elimina del árbol de forma permanente.
  @override
  void dispose() {
    // TODO: off del socket
    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }
    super.dispose();
  }
}
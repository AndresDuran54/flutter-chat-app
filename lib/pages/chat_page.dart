import 'dart:developer';
import 'dart:io';

import 'package:chat/models/mensajes_resp.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_mesage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  //Servicios
  late SocketService socketService;
  late ChatService chatService;
  late AuthService authService;

  @override
  void initState() {
    socketService = Provider.of<SocketService>(context, listen: false); 
    chatService = Provider.of<ChatService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    //Indicamos al socket que escuche el evento mensaje-privado
    //y asignamos el callback
    socketService.socket.on('mensaje-privado', _recibirMensaje);

    _obtenerMensajes();

    super.initState();
  }

  Future<void> _obtenerMensajes() async{

    List<Mensaje> mensajes = await chatService.obtenerMensajes();

    mensajes = List.from(mensajes.reversed);

    final hystori = mensajes.map((m) => ChatMessage(
      text: m.mensaje, 
      uid: m.de, 
      animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 0)
        )..forward(),
      )
    );

    _messages.insertAll(0, hystori);
  
    setState(() {
      
    });
  }

  _recibirMensaje(dynamic payload){

    log(payload);

    final newMessage = ChatMessage(
      text: payload["mensaje"], 
      uid: payload["de"],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
      ),
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    newMessage.animationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(chatService.usuarioPara.nombre.substring(0,2)),
              maxRadius: 13,
            ),
            const SizedBox(height: 3),
            Text(chatService.usuarioPara.nombre, style: TextStyle(color: Colors.black))
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
      uid: authService.usuario.uid,
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

    //Emitimos el evento mensaje-privado al servidor
    socketService.socket.emit('mensaje-privado', {
      "de": authService.usuario.uid,
      "para": chatService.usuarioPara.uid,
      "mensaje": texto 
    });

    _focusNode.requestFocus();
    _textController.clear();
  }

  //Se llama cuando este objeto se elimina del árbol de forma permanente.
  @override
  void dispose() {

    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }

    //Dejamos de escuchar al evento mensaje-privado
    socketService.socket.off('mensaje-privado');

    super.dispose();
  }
}
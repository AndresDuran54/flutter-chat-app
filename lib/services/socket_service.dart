import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {

    final token = await AuthService.getToken();

    _socket = IO.io('http://192.168.1.4:3000/', {
      'transports': ['websocket'],
      //Ya sea para conectarse automáticamente al momento de la creación. Si se establece en falso, debe conectarse manualmente:
      /*
        const socket = io({
          autoConnect: false
        });

        socket.connect();
        // or
        socket.io.open();
      */
      'autoConnect': true,
      'forceNew': true,
      //Encabezados adicionales (que luego se encuentran en el objeto socket.handshake.headers en el lado del servidor).
      'extraHeaders': {
        'x-token': token
      }
    }); 

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect(){
    _socket.disconnect();
  }

}
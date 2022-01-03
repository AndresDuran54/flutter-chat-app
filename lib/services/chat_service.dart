import 'dart:developer';

import 'package:chat/global/environment.dart';
import 'package:chat/models/mensajes_resp.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier{

  late Usuario usuarioPara;

  Future<List<Mensaje>> obtenerMensajes() async{

    final url = Uri.parse('${Environment.urlServer}/mensajes/${usuarioPara.uid}');

    final resp = await http.get(url, headers: {
      "Content-Type": "application/json",
      "x-token": await AuthService.getToken()
    });

    final mensajesResponse = mensajesResponseFromJson(resp.body);

    log(mensajesResponse.mensajes.toString());

    return mensajesResponse.mensajes;
  }

}
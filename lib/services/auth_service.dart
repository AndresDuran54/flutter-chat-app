import 'dart:convert';
import 'dart:developer';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_resp.dart';
import 'package:chat/models/usuario.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AuthService with ChangeNotifier{

  late Usuario usuario;
  bool _autenticando = false;

  //Un complemento de Flutter para almacenar datos en un almacenamiento seguro
  final _storage = FlutterSecureStorage();

  bool get autenticando => _autenticando;

  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final String token = await _storage.read(key: 'token') ?? "";
    return token;
  }

  static Future<void> eliminarToken() async{
    final _storage = FlutterSecureStorage();
    _storage.delete(key: 'token');
  }
  

  Future<bool> login (String email, String password) async{

    _autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    ///Uri.http("example.org", "/path", { "q" : "dart" });/
    final url = Uri.parse('${Environment.urlServer}/login');

    final resp = await http.post(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json'
    });

    _autenticando = false;

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      log(await AuthService.getToken());
      return true;
    }else{
      return false;
    }

  }

  Future<dynamic> register (String nombre, String email, String password) async{
    
    _autenticando = true;

    final data = {
      "nombre": nombre,
      "email": email,
      "password": password
    };

    final url = Uri.parse('${Environment.urlServer}/login/new');

    final resp = await http.post(url, body: jsonEncode(data), headers: {
      "Content-Type": "application/json"
    }); 

    _autenticando = false;

    if(resp.statusCode == 200){

      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;

    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async{

    final token = await _storage.read(key: 'token') ?? 'asd';

    log(token);

    final url = Uri.parse('${Environment.urlServer}/login/renew');

    final resp = await http.get(url, headers: {
      "Content-Type": "application/json",
      "x-token": token
    }); 

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      await logout();
      return false;
    }
  }

  _guardarToken (String token) async {
    await _storage.write(key: 'token', value: token);
  }

  logout() async{
    await _storage.delete(key: 'token');
  }

}

import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

//Widget Function(BuildContext) -> una function que retorna un Widget y tiene como parametro un objeto BuildContext
final Map<String, Widget Function(BuildContext)> appRoutes = {
  "usuarios": (BuildContext context) => UsuariosPage(),
  "chat": (BuildContext context) => ChatPage(),
  "login": (BuildContext context) => LoginPage(),
  "register": (BuildContext context) => RegisterPage(),
  "loading": (BuildContext context) => LoadingPage(),
};
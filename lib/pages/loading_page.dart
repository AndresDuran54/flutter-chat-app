import 'dart:developer';

import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginState(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        return const Center(
          child: CircularProgressIndicator()
        );
      },

    );
  }

  Future<void> checkLoginState(BuildContext context) async{

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final band = await authService.isLoggedIn();

    log('$band');

    if(band){
      socketService.connect();
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuariosPage(),
          transitionDuration: const Duration(milliseconds: 500)
        ),
      );
    }else{
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: const Duration(milliseconds: 500)
        )
      );
    }

  }
}
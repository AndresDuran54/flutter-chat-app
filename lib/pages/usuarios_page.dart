import 'dart:developer';

import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat/models/usuario.dart';

class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();

}

class _UsuariosPageState extends State<UsuariosPage> {
  /*
    Un controlador del estado de nuestro SmartRefresher
  */
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'Maria', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Mario', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Marisol', email: 'test3@test.com', online: true),
    Usuario(uid: '4', nombre: 'Maritere', email: 'test4@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( usuario.nombre, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () async {
            //await AuthService.eliminarToken();
            log(await AuthService.getToken());
            //Navigator.pushReplacementNamed(context, 'login');
          }, 
          icon: const Icon(Icons.exit_to_app, color: Colors.black)
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            //child: Icon(Icons.check_circle, color: Colors.blueAccent),
            child: const Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        header: const WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue),
          waterDropColor: Colors.blueAccent,
        ),
        //Función que se ejecuta cuando se ejecuta un poll refresh
        onRefresh: _cargarUsuarios,
        child: _listViewUsuaurios(),
      )
   );
  }

  ListView _listViewUsuaurios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) => _usuarioListTile(usuarios[i]), 
      separatorBuilder: (BuildContext context, int index) => const Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0,2)),
        backgroundColor: Colors.teal,
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(5)
        ),
      ),
    );
  }

  _cargarUsuarios() async{
    await Future.delayed(Duration(milliseconds: 1000));
    //con nuestro controlador indicamos que hemos completado el refresh
    _refreshController.refreshCompleted();
  }
}
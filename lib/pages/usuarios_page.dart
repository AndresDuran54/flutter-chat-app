import 'dart:developer';

import 'package:chat/models/usuario.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/usuarios_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();

}

class _UsuariosPageState extends State<UsuariosPage> {
  /*
    Un controlador del estado de nuestro SmartRefresher
  */
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuariosService = UsuarioService(); 
  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( usuario.nombre, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () async {
            socketService.disconnect();
            await AuthService.eliminarToken();
            Navigator.pushReplacementNamed(context, 'login');
          }, 
          icon: const Icon(Icons.exit_to_app, color: Colors.black)
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus.index == 0)?
                    const Icon(Icons.check_circle, color: Colors.blueAccent) 
                    :
                    const Icon(Icons.offline_bolt, color: Colors.red),
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async{
    usuarios = await usuariosService.obtenerUsuarios();
    setState(() {
    });
    _refreshController.refreshCompleted();
  }


}
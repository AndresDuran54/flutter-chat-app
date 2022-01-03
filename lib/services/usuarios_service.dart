import 'package:chat/global/environment.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_resp.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuarioService{

  Future<List<Usuario>> obtenerUsuarios() async{ 
    try{

      final url = Uri.parse('${Environment.urlServer}/usuarios');

      final resp = await http.get(url, 
      headers: {
        'Content-Type': 'application-json',
        'x-token': await AuthService.getToken() 
      });

      final usuariosResponse = usuarioResponseFromJson(resp.body);

      return usuariosResponse.usuarios;

    }catch(e){
      return [];
    }
  }

}
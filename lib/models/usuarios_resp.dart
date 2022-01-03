import 'dart:convert';

import 'package:chat/models/usuario.dart';

UsuariosResponse usuarioResponseFromJson(String str) => UsuariosResponse.fromJson(json.decode(str));

String usuarioResponseToJson(UsuariosResponse data) => json.encode(data.toJson());

class UsuariosResponse {
    UsuariosResponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<Usuario> usuarios;

    factory UsuariosResponse.fromJson(Map<String, dynamic> json) => UsuariosResponse(
        ok: json["ok"],
        //List<>.map -> retorna un Iterable y List<>.from crea una lista a través de un iterable
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}
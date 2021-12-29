import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(222, 222, 248, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Logo(titulo: "Registro"),
                _Form(),
                SizedBox(height: 0),
                Labels(
                  ruta: "login",
                  txt1: "¿Ya tienes cuenta?",
                  txt2: "¡Ingresa ahora!"
                ),
                SizedBox(height: 20),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {

  //en el constructos de TEC text => valor por defecto del TextField
  final emailCtrl = new TextEditingController();
  final passCtrl = new TextEditingController();
  final nombreCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nombreCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outlined,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline, 
            placeholder: "Password", 
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            callback: authService.autenticando?
              null
              :
              () async {
              final band = await authService.register(nombreCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
              if(band == true){
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                mostarAlerta(context, 'Campo inválido', band);
              }
            },
            texto: "Ingresar",
          )
        ],
      ),
    );
  }
}

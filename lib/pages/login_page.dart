import 'package:chat/widgets/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoginPage extends StatelessWidget {

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
                Logo(titulo: "Messenger"),
                _Form(),
                SizedBox(height: 0),
                Labels(
                  ruta: "register", 
                  txt1: '¿No tienes cuenta?', 
                  txt2: '¡Crea una ahora!'
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
      child: Column(
        children: <Widget>[
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
            callback: () {
              
            },
            texto: "Ingresar",
          )
        ],
      ),
    );
  }
}

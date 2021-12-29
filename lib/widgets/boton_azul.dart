import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final void Function()? callback; 

  final String texto;

  BotonAzul ({
    Key? key,
    required this.texto,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: Colors.grey,
      color: Colors.blueAccent,
      elevation: 2,
      shape: const StadiumBorder(),
      onPressed: callback,
      child: Container(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17
            ),
          ),
        ),
      ),
    );
  }
}
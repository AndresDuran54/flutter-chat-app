import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta, txt1, txt2;
  
  const Labels({
    Key? key, 
    required this.ruta,
    required this.txt1, 
    required this.txt2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(txt1, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w400)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(
              txt2, 
              style: const TextStyle(
                color: Colors.blueAccent, 
                fontSize: 18, 
                fontWeight: FontWeight.bold
              )
            )
          )
        ],
      ),
    );
  }
}

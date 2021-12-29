
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostarAlerta(BuildContext context, String titulo, String subtitulo) {

  if(Platform.isAndroid){
    return showDialog(
      context: context, 
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
              elevation: 4,
              textColor: Colors.blue,
            )
          ],
        ),
    );

  }

  showCupertinoDialog(
    context: context, 
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );
  
}
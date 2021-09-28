import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class alertDialogModel extends StatelessWidget {
  final String number;

  alertDialogModel({required this.number});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Excelente eleccion al elegir el numero $number, suerte en su jugada!'),
      elevation: 24.0,
      actions: [
        Center(child: FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('Okay')))
      ],
    );
  }
}

class alertDenialDialog extends StatelessWidget {
  final String number;

  alertDenialDialog({ required this.number});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('El numero $number ya ha sido jugado por otra persona, jugar otro numero si es deseado'),
    );
  }
}


class alertDialogTypeOfAccount extends StatelessWidget {
  final String alertMessage;



   alertDialogTypeOfAccount({ required this.alertMessage});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(alertMessage),
      elevation: 12,
      actions: [
        Center(child: FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('Okay')))
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
      ),
    );
  }
}


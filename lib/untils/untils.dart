import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showFlushbar(BuildContext context, int statusCode) {
  String text = '';
  Color color = Colors.blue;
  Icon icon = Icon(
    Icons.spa,
    size: 28.0,
    color: Colors.blue[300],
  );

  switch (statusCode) {
    case 200:
      text = 'Успішно $statusCode';
      color = Color(0xFF81C784);
      icon = Icon(
        Icons.done,
        size: 28.0,
        color: Colors.green[500],
      );
      break;
    case 500:
      text = 'Помилка $statusCode';
      color = Color(0xFFE57373);
      icon = Icon(
        Icons.error,
        size: 28.0,
        color: Colors.red[500],
      );
      break;
    default:
      text = 'Погане фото, відправте повторно $statusCode';
      color = Color(0xFFFFF176);
      icon = Icon(
        Icons.refresh,
        size: 28.0,
        color: Colors.yellow[500],
      );
  }

  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    message: text,
    icon: icon,
    duration: Duration(seconds: 3),
    leftBarIndicatorColor: color,
  )..show(context);
}

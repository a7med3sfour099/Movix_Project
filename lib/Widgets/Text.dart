import 'package:flutter/widgets.dart';

Widget text(String data, {double? size, Color? color, FontWeight? weight}){
  return Text(
        data,
        style: TextStyle(
        fontSize: size ?? 12,
        color: color ?? Color(0xFF061614),
        fontWeight: weight ?? FontWeight.normal,
        fontFamily: 'PlusJakartaSans'
        )
  );
}
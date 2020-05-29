import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  const CustomText({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 40,
          color: Colors.green,
          decoration: TextDecoration.underline),
    );
  }
}

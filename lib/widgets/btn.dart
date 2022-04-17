// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var btnText;

  // ignore: prefer_typing_uninitialized_variables
  var onClick;

  ButtonWidget(this.btnText, this.onClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf7d9cb), Color(0xFFf1c7b2)],
            end: Alignment.centerLeft,
            begin: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          btnText,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

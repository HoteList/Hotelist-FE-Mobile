// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderContainer extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var text;

  HeaderContainer(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFf7d9cb), Color(0xFFf1c7b2)],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: SvgPicture.asset(
              'assets/icons/logo_icon.svg',
              width: 120,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/screens/home_screen.dart';
import 'package:hotelist_fe_mobile/screens/regist.dart';
import 'package:hotelist_fe_mobile/widgets/btn.dart';

import '../widgets/header_container.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer('Login'),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _textInput(
                        hint: 'Username', icon: Icons.account_circle_sharp),
                    _textInput(hint: 'Password', icon: Icons.vpn_key),
                    // Container(
                    //   margin: const EdgeInsets.only(top: 10),
                    //   alignment: Alignment.centerRight,
                    //   child: const Text('Forgot Password?'),
                    // ),
                    Expanded(
                      child: Center(
                        child: ButtonWidget("LOGIN", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: const TextSpan(
                    text: "Don't have an account ? ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Registration()));
                  },
                  child: const Text("Register", style: TextStyle(color: Color(0xFFdb9069)),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
Widget _textInput({controller, hint, icon}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
    ),
    padding: const EdgeInsets.only(left: 10),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    ),
  );
}

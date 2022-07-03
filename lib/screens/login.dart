import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/screens/home_screen.dart';
import 'package:hotelist_fe_mobile/screens/regist.dart';
import 'package:hotelist_fe_mobile/widgets/btn.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

import '../models/user_model.dart';
import '../widgets/header_container.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool error = false;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Form(
          key: _formKey,
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
                          controller: username, hint: 'Username', icon: Icons.account_circle_sharp),
                      _textInput(controller: password, hint: 'Password', icon: Icons.vpn_key),
                      if (error) (
                        Container(margin: const EdgeInsets.all(19.0), padding: const EdgeInsets.all(8.0), color: Color.fromARGB(255, 255, 176, 123), child: 
                          const Text("UNAUTHENTICATED!", style: TextStyle(color: Colors.black))
                        ,)
                      ),
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 219, 145, 105)
                            ),
                            child: const Text("LOGIN"),
                            onPressed: () async {
                              try {
                                final user = await login(username.text, password.text);
                                
                                setState(() {
                                  error = false;

                                  username.text = "";
                                  password.text = "";
                                });

                                await UserSecureStorage.setToken(user.token);
                                await UserSecureStorage.setId(user.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ));
                              } catch (e) {
                                setState(() {
                                  error = true;
                                });
                              }
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
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Color.fromARGB(255, 219, 145, 105)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _textInput({controller, hint, icon}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
    ),
    padding: const EdgeInsets.only(left: 10),
    child: TextFormField(
      obscureText: hint == "Password" ? true : false,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(icon),
        prefixIconColor: const Color.fromARGB(255, 219, 145, 105)
      ),
      validator: (controller) {
        if (controller!.isEmpty) {
          return 'Please enter your Username';
        }
        return null;
      },
    ),
  );
}

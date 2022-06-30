import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/screens/home_screen.dart';
import 'package:hotelist_fe_mobile/screens/login.dart';

import '../models/user_model.dart';
import '../utils/user_secure_storage.dart';
import '../widgets/header_container.dart';

class Registration extends StatefulWidget {
  const Registration({ Key? key }) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

  bool error = false;

  TextEditingController full_name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password_confirmation = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            HeaderContainer('Sign Up'),
            Form(
              key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 30,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _textInput(
                                controller: full_name, hint: 'Full Name', icon: Icons.account_circle_sharp),
                            _textInput(controller: username, hint: 'Username', icon: Icons.account_box),
                            _textInput(controller: email, hint: 'Email', icon: Icons.email),
                            _textInput(controller: password, hint: 'Password', icon: Icons.vpn_key),
                            _textInput(controller: password_confirmation, hint: 'Password Confirmation', icon: Icons.vpn_key),
                    
                            if (error) (
                              Container(margin: EdgeInsets.all(19.0), padding: EdgeInsets.all(8.0), color: Color.fromARGB(255, 255, 176, 123), child: 
                                Text("Registration Error!", style: TextStyle(color: Colors.black))
                              ,)
                            ),
                            Center(
                                child: ElevatedButton(
                                  child: const Text("Sign Up"),
                                  onPressed: () async {
                                    try {
                                      showDialog(context: context, builder: (BuildContext context) {
                                        return const CircularProgressIndicator();
                                      });
                                      final user = await signup(full_name.text, username.text, email.text, password.text ,password_confirmation.text);
                                      Navigator.pop(context);
                                      setState(() {
                                        error = false;

                                        full_name.text = "";
                                        username.text = "";
                                        email.text = "";
                                        password.text = "";
                                        password_confirmation.text = "";
                                      });

                                      await UserSecureStorage.setToken(user.token);
                                      await UserSecureStorage.setId(user.id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const HomeScreen(),
                                          ));
                                    } catch (e) {
                                      print(e);
                                      Navigator.pop(context);
                                      setState(() {
                                        error = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: const TextSpan(
                    text: "Already have an account ? ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xFFdb9069)),
                  ),
                ),
              ],
            ),
          ],
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
      
      obscureText: hint == "Password" || hint == "Password Confirmation" ? true : false,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(icon),
        prefixIconColor: const Color(0xFFdb9069)
      ),
      validator: (controller) {
        if (controller!.isEmpty) {
          return 'Please enter your Username';
        }
      },
    ),
  );
}
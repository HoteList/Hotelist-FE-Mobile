import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/models/user_model.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class Edit_Profile_page extends StatefulWidget {

  final User user;

  const Edit_Profile_page({ Key? key, required this.user }) : super(key: key);

  @override
  _Edit_Profile_page createState() => _Edit_Profile_page(user);
}

class _Edit_Profile_page extends State<Edit_Profile_page> {

  User user;
  _Edit_Profile_page(this.user);

  TextEditingController full_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();

  String image = "";

  void initState() {
    setState(() {
      image = user.image;
    });

    full_name.text = user.full_name;
    email.text = user.email;
    username.text = user.username;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
        titleSpacing: -40.0,
      ),
      body: Column(children: <Widget>[
        Center(child: 
          Column(children: [
            Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            _textInput(controller: full_name, hint: 'full_name',),
            SizedBox(height: 25,),
            Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            _textInput(controller: email, hint: 'email',),                        SizedBox(height: 25,),
            Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            _textInput(controller: username, hint: 'username',),
            ElevatedButton(
              onPressed: () {
                updateUser(full_name.text, email.text, username.text, image);
                Navigator.pop(context);
              }, 
              child: Text("Submit")
            )
          ])
        )
      ]),
    );
  }
}

Widget _textInput({controller, hint}) {
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
        prefixIconColor: const Color(0xFFdb9069)
      ),
      validator: (controller) {
        if (controller!.isEmpty) {
          return 'Please enter your ${hint}';
        }
      },
    ),
  );
}
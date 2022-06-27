import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/models/user_model.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class EditProfilePage extends StatefulWidget {

  final User user;

  const EditProfilePage({ Key? key, required this.user }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _EditProfilePage createState() => _EditProfilePage(user);
}

class _EditProfilePage extends State<EditProfilePage> {

  User user;
  _EditProfilePage(this.user);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.amber.shade700),
        titleSpacing: -10.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16,top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  _textInput(controller: full_name, hint: 'full_name',),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  _textInput(controller: email, hint: 'email',),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  _textInput(controller: username, hint: 'full_name',),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child:
                ElevatedButton(
                  onPressed: () {
                    updateUser(full_name.text, email.text, username.text, image);
                    Navigator.pop(context);
                  }, 
                  child: const Text("Edit")
                ),
            ),
          ],
        ),
      ),
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
    padding: const EdgeInsets.only(left: 20),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIconColor: const Color(0xFFdb9069)
      ),
      validator: (controller) {
        if (controller!.isEmpty) {
          return 'Please enter your $hint';
        }
        return null;
      },
    ),
  );
}
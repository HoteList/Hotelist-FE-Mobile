import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelist_fe_mobile/screens/home_screen.dart';
import 'package:hotelist_fe_mobile/screens/login.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late Future<String?> futureToken;

  @override
  void initState() {
    super.initState();

    futureToken = UserSecureStorage.getToken();

    Timer(const Duration(milliseconds: 1000), () {
      futureToken.then((value) {
        if (value != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf7d9cb), Color(0xFFf1c7b2)],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter
          ),
        ),
        child: Center(
          child: SvgPicture.asset('assets/icons/logo_icon.svg', width: 120,),
        ),
      ),
    );
  }
}
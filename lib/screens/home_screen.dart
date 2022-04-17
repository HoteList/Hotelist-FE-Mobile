import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
      ),
    );
  }
}
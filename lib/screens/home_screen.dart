import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/screens/list_hotel.dart';
import 'package:hotelist_fe_mobile/screens/profile.dart';
import 'package:hotelist_fe_mobile/screens/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController search = TextEditingController();

  int _selectId = 0;
  final List<dynamic> _widgetOption = [
    const ListHotel(),
    const TransactionPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
        titleSpacing: -40.0,
      ),
      body: Container(child: 
        _widgetOption.elementAt(_selectId)       
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          // backgroundColor: const Color.fromARGB(255, 219, 145, 105),
          color: const Color.fromARGB(255, 219, 145, 105),
          activeColor: const Color.fromARGB(255, 219, 145, 105),
          tabBackgroundColor: const Color.fromARGB(255, 247, 217, 203),
          gap: 8,
          padding: const EdgeInsets.all(10),
          onTabChange: (index) {
            setState(() => _selectId = index);
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home",),
            GButton(icon: Icons.my_library_books_rounded, text: "Transaction"),
            GButton(icon: Icons.person, text: "Account",)
          ],
        ),
      ),
    );
  }
}
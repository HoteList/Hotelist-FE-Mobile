import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    const Text("Search"),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.orange),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.orange),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money, color: Colors.orange),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.orange),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectId,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() => _selectId = index);
        }
      ),
    );
  }
}
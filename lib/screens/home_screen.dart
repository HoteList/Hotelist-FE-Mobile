import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
// import 'package:hotelist_fe_mobile/screens/profile.dart';
// import 'package:hotelist_fe_mobile/screens/transaction.dart';
import 'package:hotelist_fe_mobile/screens/hotel_details.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';

import '../models/hotel_model.dart';
// import '../models/room_detail_model.dart';
// import '../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController search = TextEditingController();

  int _selectId = 0;
  final List<dynamic> _widgetOption = [
    Container(child:
      Column(children: [
        Text("Hello, Welcome to Hotelist", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        SizedBox(height: 10),
        Text("Find Hotel Here", style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5)),),
        _textInput(controller: TextEditingController(), hint: 'Search', icon: Icons.search),
        Expanded(child: 
          FutureBuilder<List<Hotel>>(
            future: getHotels(),
            builder: (BuildContext context, AsyncSnapshot<List<Hotel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                        width: 100,
                        height: 100,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int idx) {
                            return Image.network(
                              snapshot.data![index].image!.split(",")[idx],
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            );
                          },
                          itemWidth: 100,
                          itemHeight: 100,
                          itemCount: snapshot.data![index].image!.split(",").length,
                          autoplay: true,
                          autoplayDelay: 3000,
                          layout: SwiperLayout.DEFAULT,
                        ),),
                      
                      title: Column(children: [
                        Text(snapshot.data![index].name!, style: TextStyle(fontWeight: FontWeight.bold)),
                        if (snapshot.data![index].description!.length > 50) (
                            Text(snapshot.data![index].description!.substring(0, 47) + "...", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                          ) else (
                            Text(snapshot.data![index].description!, style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      contentPadding: EdgeInsets.all(8.0),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HotelDetails(
                              hotel: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                    );
                  }
                );
              } else if (snapshot.hasError) {
                UserSecureStorage.deleteToken();
                return Text("${snapshot.error}");
              } else {
                return SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
              }
            }
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: EdgeInsets.all(12.0),
    ),
    Text("Search"),
    // Transaction_page(),
    // Profile_page()
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
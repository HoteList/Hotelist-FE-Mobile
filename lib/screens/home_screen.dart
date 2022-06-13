import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelist_fe_mobile/constants/color_constant.dart';
import 'package:hotelist_fe_mobile/utils/user_secure_storage.dart';
import '../models/hotel_model.dart';
import '../models/room_detail_model.dart';
import '../models/transaction_model.dart';

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
        titleSpacing: -40.0,
      ),
      body: Center(child:
        FutureBuilder<List<Hotel>>(
          future: getHotels(),
          builder: (BuildContext context, AsyncSnapshot<List<Hotel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(child:
                    Row(children: [
                      // leading: Image.network(
                      //   "",
                      //   fit: BoxFit.cover,
                      //   width: 50,
                      //   height: 50, 
                      // ),
                      const Padding(padding: EdgeInsets.all(8.0)),
                      Text(snapshot.data![index].name!),
                      const SizedBox(width: 50),
                      if (snapshot.data![index].description!.length > 50) (
                        Text(snapshot.data![index].description!.substring(0, 47) + "...")
                       ) else (
                        Text(snapshot.data![index].description!)
                       )
                    ]),
                    padding: const EdgeInsets.all(1.0),
                    alignment: Alignment.centerLeft,
                  );
                }
              );
            } else {
              return Text("${snapshot.error}");
            }
          }
        ),
      ),
    );
  }
}
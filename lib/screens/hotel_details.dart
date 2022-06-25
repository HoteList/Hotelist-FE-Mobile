import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotelist_fe_mobile/models/hotel_model.dart';
import 'package:hotelist_fe_mobile/models/room_detail_model.dart';
import '../constants/color_constant.dart';
import '../utils/geocode_location.dart';
import '../utils/user_secure_storage.dart';

class HotelDetails extends StatefulWidget {
  final Hotel hotel;
  const HotelDetails({ Key? key, required this.hotel }) : super(key: key);

  @override
  _HotelDetailsState createState() => _HotelDetailsState(hotel);
}

class _HotelDetailsState extends State<HotelDetails> {
  Hotel hotel;
  String address = "";
  bool flag = true;
  _HotelDetailsState(this.hotel);
  void coba (double? lat, double? lot) async {
    final res = await GeocodeLocation.getAddress(lat, lot);
    print(res);
  }
  void initState() {
    if (hotel.lat == null || hotel.lot == null) {
      setState(() => {
        address = "Unknown"
      });
      return;
    }
    // coba(double.tryParse(hotel.lat!), double.tryParse(hotel.lot!));
    // GeocodeLocation.getAddress(double.tryParse(hotel.lat!), double.tryParse(hotel.lot!))
    // .then((value)  {
      
    //   setState(() => {
        // address = value!
    //   });
    // });

    // setState(() {
    //   address = GeocodeLocation.getAddress(double.tryParse(hotel.lat!), double.tryParse(hotel.lot!));
    //   print(address);
    // });
  }
  // Future<String> address = GeocodeLocation.getAddress(double.tryParse(widget.hotel.lat!), double.tryParse(widget.hotel.lot!));
  // static Future<String> getAddress(double lat, double lot) {
  //   GeocodeLocation.getAddress(lat, lot).then((value) => value);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackGroundColor,
        title: SvgPicture.asset('assets/icons/logo.svg', width: MediaQuery.of(context).size.width / 3,),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.amber.shade700),
        titleSpacing: -10.0,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Swiper(
              itemBuilder: (BuildContext context, int idx) {
                return Image.network(
                  widget.hotel.image!.split(",")[idx],
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                );
              },
              itemWidth: 100,
              itemHeight: 100,
              itemCount: widget.hotel.image!.split(",").length,
              autoplay: true,
              autoplayDelay: 3000,
              layout: SwiperLayout.DEFAULT,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  widget.hotel.name!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_pin,
                          color: Colors.amber.shade700,
                        ),
                         Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            // GeocodeLocation.getAddress(double.tryParse(widget.hotel.lat!), double.tryParse(widget.hotel.lot)),
                            address.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.hotel,
                          color: Colors.amber.shade700,
                        ),
                        Text(
                          "${widget.hotel.capacity.toString()} kamar tersedia",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  children: [
                    if (widget.hotel.description!.length > 100 && flag) (
                      Text(widget.hotel.description!.substring(0, 97) + "...")
                      
                    ) else (
                      Text(widget.hotel.description!)
                    ),
                    if (widget.hotel.description!.length > 100 && flag) (
                      TextButton(child: Text("Show More"), onPressed: () {
                        setState(() {
                          flag = false;
                        });
                      },)
                    ) else (
                      TextButton(child: Text("Show Less"), onPressed: () {
                        setState(() {
                          flag = true;
                        });
                      },)
                    )
                  ],
                )
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Text(
                  "Room Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: FutureBuilder<List<RoomDetail>>(
                    future: getRoomDetailsByHotelId(widget.hotel.id),
                    builder: (BuildContext context, AsyncSnapshot<List<RoomDetail>> snapshot) {
                      if (snapshot.hasData) {
                        // return Text("data");
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
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
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => HotelDetails(
                                //       hotel: snapshot.data![index],
                                //     ),
                                //   ),
                                // );
                              },
                            );
                          }
                        );
                      } else if (snapshot.hasError) {
                        UserSecureStorage.deleteToken();
                        // UserSecureStorage.deleteId();
                        return Text("${snapshot.error}");
                      } else {
                        return SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
                      }
                    },
                  )
                )
            ],
          )
        ],
      )
    );
  }
}
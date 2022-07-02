import 'dart:async';
import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hotelist_fe_mobile/widgets/searchbar.dart';

import '../models/hotel_model.dart';
import '../utils/geocode_location.dart';
import '../utils/user_geolocator.dart';
import 'hotel_details.dart';

class ListHotel extends StatefulWidget {
  const ListHotel({ Key? key }) : super(key: key);

  @override
  State<ListHotel> createState() => _ListHotelState();
}

class _ListHotelState extends State<ListHotel> {
  List<Hotel> hotels = [];
  List<Hotel> nearbyHotels = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final currentPosition = await UserGeolocator.getCurrentPosition();
    final hotels = await getHotels(query);
    double totalDistance = 0;

    for (var i = 0; i < hotels.length; i++) {
      if (hotels[i].lat != null && hotels[i].lot != null) {
        totalDistance += calculateDistance(
          double.tryParse(hotels[i].lat!),
          double.tryParse(hotels[i].lot!),
          currentPosition.latitude,
          currentPosition.longitude
        );

        if (totalDistance < 100000) {
          nearbyHotels.add(hotels[i]);
        }
      }
    }

    setState(() {
      this.hotels = hotels;
      nearbyHotels = nearbyHotels;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 + 
          cos(lat1 * p) * cos(lat2 * p) * 
          (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<String?> getAddress(double? lat, double? lot) async {
    final res = await GeocodeLocation.getAddress(lat, lot);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Hello, Welcome to Hotelist", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          SearchWidget(text: query, onChanged: searchHotel, hintText: "Hotel's Name"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nearby Hotels",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: Color.fromARGB(255, 219, 145, 105),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 190,
            child: ListView.builder(
              itemCount: nearbyHotels.length > 5 ? 5 : nearbyHotels.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HotelDetails(
                        hotel: nearbyHotels[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          height: MediaQuery.of(context).size.height / 6,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int idx) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  nearbyHotels[index].image!.split(",")[idx],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            itemCount: hotels[index].image!.split(",").length,
                            autoplay: true,
                            autoplayDelay: 3000,
                            layout: SwiperLayout.DEFAULT,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  nearbyHotels[index].name!,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                margin: const EdgeInsets.only(bottom: 10),
                              ),
                              if (nearbyHotels[index].description!.length > 50) (
                                Text(nearbyHotels[index].description!.substring(0, 30) + "...", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                              ) else (
                                Text(nearbyHotels[index].description!, style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                              )
                            ],
                          ) 
                        ),
                      ],
                    ),
                  ),
                ),
              ) ,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: const Text(
              "All Hotels",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    width: 100,
                    height: 100,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int idx) {
                        return Image.network(
                          hotels[index].image!.split(",")[idx],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        );
                      },
                      itemWidth: 100,
                      itemHeight: 100,
                      itemCount: hotels[index].image!.split(",").length,
                      autoplay: true,
                      autoplayDelay: 3000,
                      layout: SwiperLayout.DEFAULT,
                    ),
                  ),
                  title: Column(
                    children: [
                      Text(hotels[index].name!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (hotels[index].description!.length > 50) (
                        Text(hotels[index].description!.substring(0, 47) + "...", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                      ) else (
                        Text(hotels[index].description!, style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HotelDetails(
                          hotel: hotels[index],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: const EdgeInsets.all(16.0),
    );
  }

  Future searchHotel(String query) async => debounce(() async {
    final hotels = await getHotels(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.hotels = hotels;
    });
  });
}

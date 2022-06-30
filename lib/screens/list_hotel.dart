import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/widgets/searchbar.dart';

import '../models/hotel_model.dart';
import 'hotel_details.dart';

class ListHotel extends StatefulWidget {
  const ListHotel({ Key? key }) : super(key: key);

  @override
  State<ListHotel> createState() => _ListHotelState();
}

class _ListHotelState extends State<ListHotel> {
  List<Hotel> hotels = [];
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
    final hotels = await getHotels(query);

    setState(() => this.hotels = hotels);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:
      Column(children: [
        const Text("Hello, Welcome to Hotelist", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        // SizedBox(height: 10),
        // Text("Find Hotel Here", style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5)),),
        SearchWidget(text: query, onChanged: searchHotel, hintText: "Hotel's Name"),
        Expanded(
          child: ListView.builder(
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
                  ),),
                
                title: Column(children: [
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

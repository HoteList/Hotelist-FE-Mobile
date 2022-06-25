import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hotelist_fe_mobile/models/hotel_model.dart';

class HotelDetails extends StatelessWidget {
  final Hotel hotel;
  const HotelDetails({ Key? key, required this.hotel }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Detail"),
      ),
      body: Swiper(
              itemBuilder: (BuildContext context, int idx) {
                return Image.network(
                  hotel.image!.split(",")[idx],
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                );
              },
              itemWidth: 100,
              itemHeight: 100,
              itemCount: hotel.image!.split(",").length,
              autoplay: true,
              autoplayDelay: 3000,
              layout: SwiperLayout.DEFAULT,
            ),
    );
  }
}
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotelist_fe_mobile/models/room_detail_model.dart';
import 'package:intl/intl.dart';

import '../constants/color_constant.dart';

class RoomDetails extends StatefulWidget {
  final RoomDetail roomDetail;
  const RoomDetails({ Key? key, required this.roomDetail }) : super(key: key);

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  DateTime nowDate = DateTime.now();
  DateTime? newDate;
  bool flag = true;
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
                  widget.roomDetail.image!.split(",")[idx],
                  fit: BoxFit.cover,  
                );
              },
              itemCount: widget.roomDetail.image!.split(",").length,
              autoplay: widget.roomDetail.image!.split(",").length > 1 ? true : false,
              autoplayDelay: 3000,
              layout: SwiperLayout.DEFAULT,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roomDetail.name!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
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
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              // GeocodeLocation.getAddress(double.tryParse(widget.hotel.lat!), double.tryParse(widget.hotel.lot)),
                              "address",
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
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "${widget.roomDetail.capacity.toString()} kamar",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.roomDetail.description!.length > 100 && flag) (
                        Text(widget.roomDetail.description!.substring(0, 97) + "...")
                      ) else (
                        Text(widget.roomDetail.description!)
                      ),
                      if (widget.roomDetail.description!.length > 100 && flag) (
                        TextButton(child: Text(
                          "Show More",
                          style: TextStyle(
                            color: Colors.amber.shade700
                          ),
                        ), onPressed: () {
                          setState(() {
                            flag = false;
                          });
                        },)
                      ) else if (widget.roomDetail.description!.length > 100 && !flag) (
                        TextButton(child: Text(
                          "Show Less",
                          style: TextStyle(
                            color: Colors.amber.shade700
                          ),
                        ), onPressed: () {
                          setState(() {
                            flag = true;
                          });
                        },)
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.amber.shade700,),
                    TextButton(
                      child: Text(
                        newDate != null ? DateFormat('EEEE, dd-MM-yyyy').format(newDate!) : DateFormat('EEEE, dd-MM-yyyy').format(nowDate),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: newDate != null ? newDate! : nowDate,
                          firstDate: nowDate,
                          lastDate: DateTime(nowDate.year + 2),
                        );
                        if (selectedDate == null) return;
                        setState(() =>
                          newDate = selectedDate
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}